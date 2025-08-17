using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class WordGame : Node2D
{
	// Referencias a nodos
	private Label instructionLabel;
	private Label timeLabel;
	//private Label attemptsLabel;
	private TextureRect[] wordSlots; // Slots donde van las letras ordenadas
	private HBoxContainer availableLettersContainer; // Contenedor de letras disponibles
	private Panel gameOverPanel;
	private Label gameOverLabel;
	private Button restartButton;
	private Timer timer;

	// Variables del juego
	private List<string> wordsList = new List<string> {
	"CASA", "GATO", "AGUA", "MESA", "LUNA",
	"AMOR", "CAFE", "VIDA", "AZUL", "ROJO",
	"FLOR", "NUBE", "PATO",
	"RAMA", "OLAS", "PERA", "LEON", "ALMA",
	"PIEL", "BESO", "PESO", "HUES", "DADO",
	"RISA", "CIMA", "HILO", "JUEZ", "FUEG",
	"SOLI", "TEMA", "LAGO", "MONO", "RATA"
};


	private string currentWord = "";
	private List<char> shuffledLetters = new List<char>();
	private List<char> placedLetters = new List<char> { '\0', '\0', '\0', '\0' }; // Letras colocadas en orden
	private List<TextureButton> availableButtons = new List<TextureButton>();
	private int currentSlot = 0; // Próximo slot donde colocar letra
	private int attempts = 0;
	private int maxAttempts = 100;
	private int wordsCompleted = 0; // Palabras completadas correctamente
	private int targetWords = 3; // Necesita completar 4 palabras para ganar
	private float gameTime = 180.0f; // 3 minutos para completar las 4 palabras
	private bool isGameActive = false;

	// Texturas de letras
	private Dictionary<char, Texture2D> letterTextures = new Dictionary<char, Texture2D>();

	public override void _Ready()
	{
		// Obtener referencias a nodos
		instructionLabel = GetNode<Label>("UI/GameInfo/InstructionLabel");
		timeLabel = GetNode<Label>("UI/GameInfo/TimeLabel");
		//attemptsLabel = GetNode<Label>("UI/GameInfo/AttemptsLabel");
		
		wordSlots = new TextureRect[] {
			GetNode<TextureRect>("UI/WordContainer/Letter1"),
			GetNode<TextureRect>("UI/WordContainer/Letter2"),
			GetNode<TextureRect>("UI/WordContainer/Letter3"),
			GetNode<TextureRect>("UI/WordContainer/Letter4")
		};
		
		availableLettersContainer = GetNode<HBoxContainer>("UI/AvailableLetters");
		gameOverPanel = GetNode<Panel>("UI/GameOverPanel");
		gameOverLabel = GetNode<Label>("UI/GameOverPanel/GameOverLabel");
		restartButton = GetNode<Button>("UI/GameOverPanel/RestartButton");
		timer = GetNode<Timer>("Timer");

		LoadLetterTextures();
		restartButton.Pressed += OnRestartButtonPressed;
		timer.Timeout += OnTimerTimeout;
		StartNewGame();
	}

	private void LoadLetterTextures()
	{
		string alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		foreach (char letter in alphabet)
		{
			string path = "res://Games/Palabras/Single PNGs/" + letter + ".png";
			if (FileAccess.FileExists(path))
			{
				letterTextures[letter] = GD.Load<Texture2D>(path);
			}
			else
			{
				GD.Print("No se encontro la textura para la letra: " + letter);
			}
		}
	}

	private void StartNewGame()
	{
		attempts = 0;
		wordsCompleted = 0;
		gameTime = 180.0f; // 3 minutos para completar 4 palabras
		isGameActive = true;
		currentSlot = 0;
		placedLetters = new List<char> { '\0', '\0', '\0', '\0' };
		
		gameOverPanel.Visible = false;
		SelectRandomWord();
		CreateShuffledLetters();
		ClearWordSlots();
		UpdateUI();
		timer.Start();
	}

	private void SelectRandomWord()
	{
		Random random = new Random();
		int randomIndex = random.Next(wordsList.Count);
		currentWord = wordsList[randomIndex];
		GD.Print("Palabra seleccionada: " + currentWord);
	}

	private void CreateShuffledLetters()
	{
		// Limpiar letras anteriores
		foreach (Node child in availableLettersContainer.GetChildren())
		{
			child.QueueFree();
		}
		availableButtons.Clear();

		// Crear lista de letras y mezclarlas
		shuffledLetters = currentWord.ToList();
		Random random = new Random();
		
		// Algoritmo Fisher-Yates para mezclar
		for (int i = shuffledLetters.Count - 1; i > 0; i--)
		{
			int j = random.Next(i + 1);
			(shuffledLetters[i], shuffledLetters[j]) = (shuffledLetters[j], shuffledLetters[i]);
		}

		// Crear botones para cada letra mezclada
		for (int i = 0; i < shuffledLetters.Count; i++)
		{
			char letter = shuffledLetters[i];
			TextureButton button = new TextureButton();
			
			if (letterTextures.ContainsKey(letter))
			{
				button.TextureNormal = letterTextures[letter];
			}
			
			button.CustomMinimumSize = new Vector2(140,120); // tamaño del botón
			button.StretchMode = TextureButton.StretchModeEnum.Scale; // hace que la imagen escale al tamaño del botón


			button.Pressed += () => OnAvailableLetterPressed(letter, button);
			availableLettersContainer.AddChild(button);
			availableButtons.Add(button);
		}
	}

	private void OnAvailableLetterPressed(char letter, TextureButton button)
	{
		if (!isGameActive || currentSlot >= 4)
			return;

		// Colocar letra en el próximo slot disponible
		placedLetters[currentSlot] = letter;
		wordSlots[currentSlot].Texture = letterTextures[letter];
		
		// Deshabilitar el botón usado
		button.Disabled = true;
		button.Modulate = Colors.Gray;
		
		currentSlot++;

		// Si completó las 4 letras, verificar la palabra
		if (currentSlot >= 4)
		{
			CheckWord();
		}
	}

	private void CheckWord()
	{
		string formedWord = "";
		foreach (char letter in placedLetters)
		{
			formedWord += letter;
		}

		if (formedWord == currentWord)
		{
			// ¡Palabra correcta!
			wordsCompleted++;
			
			if (wordsCompleted >= targetWords)
			{
				// ¡Completó las 4 palabras! ¡Ganó!
				EndGame(true);
			}
			else
			{
				// Avanzar a la siguiente palabra
				ShowCorrectWordFeedback();
				GetTree().CreateTimer(2.0).Timeout += () => {
					SelectNextWord();
				};
			}
		}
		else
		{
			// Palabra incorrecta - cambiar a nueva palabra automáticamente
			attempts++;
			if (attempts >= maxAttempts)
			{
				EndGame(false);
			}
			else
			{
				// Mostrar palabra incorrecta brevemente y luego cambiar
				ShowIncorrectWordFeedback();
				GetTree().CreateTimer(1.5).Timeout += () => {
					SelectNewWordAfterError();
				};
			}
		}
		UpdateUI();
	}

	private void ShowCorrectWordFeedback()
	{
		// Cambiar color de los slots a verde para mostrar éxito
		foreach (TextureRect slot in wordSlots)
		{
			slot.Modulate = Colors.Green;
		}
		
		// Deshabilitar botones temporalmente
		foreach (TextureButton button in availableButtons)
		{
			button.Disabled = true;
		}
	}

	private void SelectNextWord()
	{
		// Seleccionar siguiente palabra
		Random random = new Random();
		int randomIndex = random.Next(wordsList.Count);
		currentWord = wordsList[randomIndex];
		GD.Print("Siguiente palabra: " + currentWord + " (Palabra " + (wordsCompleted + 1) + "/4)");

		// Resetear para la siguiente palabra
		currentSlot = 0;
		placedLetters = new List<char> { '\0', '\0', '\0', '\0' };
		
		// Restaurar color normal de los slots
		foreach (TextureRect slot in wordSlots)
		{
			slot.Modulate = Colors.White;
			slot.Texture = null;
		}
		
		// Crear nuevas letras mezcladas para la siguiente palabra
		CreateShuffledLetters();
		UpdateUI();
	}

	private void ShowIncorrectWordFeedback()
	{
		// Cambiar color de los slots a rojo para mostrar error
		foreach (TextureRect slot in wordSlots)
		{
			slot.Modulate = Colors.Red;
		}
		
		// Deshabilitar botones temporalmente
		foreach (TextureButton button in availableButtons)
		{
			button.Disabled = true;
		}
	}

	private void SelectNewWordAfterError()
	{
		// Seleccionar nueva palabra
		Random random = new Random();
		int randomIndex = random.Next(wordsList.Count);
		currentWord = wordsList[randomIndex];
		GD.Print("Nueva palabra después de error: " + currentWord);

		// Resetear todo para la nueva palabra
		currentSlot = 0;
		placedLetters = new List<char> { '\0', '\0', '\0', '\0' };
		
		// Restaurar color normal de los slots
		foreach (TextureRect slot in wordSlots)
		{
			slot.Modulate = Colors.White;
			slot.Texture = null;
		}
		
		// Crear nuevas letras mezcladas para la nueva palabra
		CreateShuffledLetters();
		UpdateUI();
	}

	private void ResetForNewAttempt()
	{
		currentSlot = 0;
		placedLetters = new List<char> { '\0', '\0', '\0', '\0' };
		ClearWordSlots();
		
		// Rehabilitar todos los botones
		foreach (TextureButton button in availableButtons)
		{
			button.Disabled = false;
			button.Modulate = Colors.White;
		}
	}

	private void ClearWordSlots()
	{
		foreach (TextureRect slot in wordSlots)
		{
			slot.Texture = null;
		}
	}

	private void UpdateUI()
	{
		instructionLabel.Text = "Palabra " + (wordsCompleted + 1) + "/" + targetWords + " - Ordena las letras";
		timeLabel.Text = "Tiempo: " + ((int)gameTime) + "s";
		//attemptsLabel.Text = "Intentos fallidos: " + attempts + "/" + maxAttempts;
	}

	private void OnTimerTimeout()
	{
		EndGame(false);
	}

	private void EndGame(bool won)
	{
		isGameActive = false;
		timer.Stop();
		
		if (won)
		{
			gameOverLabel.Text = "¡FELICITACIONES!\n¡Completaste las " + targetWords + " palabras!\n\nPalabras completadas: " + wordsCompleted + "/" + targetWords;
		}
		else
		{
			gameOverLabel.Text = "PERDISTE\n\n";
			if (attempts >= maxAttempts)
			{
				gameOverLabel.Text += "Demasiados errores (" + attempts + "/" + maxAttempts + ")\n";
			}
			else
			{
				gameOverLabel.Text += "Se acabo el tiempo\n";
			}
			gameOverLabel.Text += "Completaste: " + wordsCompleted + "/" + targetWords + " palabras\n";
			gameOverLabel.Text += "Ultima palabra era: " + currentWord;
		}
		
		gameOverPanel.Visible = true;
	}

	private void OnRestartButtonPressed()
	{
		StartNewGame();
	}

	public override void _Process(double delta)
	{
		if (isGameActive && timer.TimeLeft > 0)
		{
			gameTime = (float)timer.TimeLeft;
			UpdateUI();
		}
	}
}
