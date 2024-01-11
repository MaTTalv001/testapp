document.addEventListener("turbo:load", function() {
  const boardsContainer = document.getElementById('boards-container');
  if (boardsContainer) {
    loadRandomBoards();
  }

  function loadRandomBoards() {
    fetch('/boards/random')
      .then(response => response.json())
      .then(boards => {
        const boardsContainer = document.getElementById('boards-container');
        boardsContainer.innerHTML = '';
        boards.forEach(board => {
          const boardElement = document.createElement('div');
          boardElement.classList.add('card', 'mt-3', 'mx-3', 'p-0', 'col-md-4');
          boardElement.style.width = '18rem';

          let boardImageHTML = '';
          if (board.image_url) {
            boardImageHTML = `<img src="${board.image_url}" class="card-img-top img-fluid">`;
            }
          boardElement.innerHTML = `
            <div class="card-img-top">
              ${boardImageHTML}
              <div class="card-img-overlay">
                <h6><span class="badge bg-secondary">${board.category}</span></h6>
              </div>
            </div>
            <div class="card-body">
              <p class="card-text">${board.body}</p>
            </div>
            <div class="d-grid gap-2 d-md-block m-3">
              <button type="button" class="btn btn-outline-primary board-button" data-board-id="${board.id}">
                めちゃR
              </button>
            </div>
          `;

          boardsContainer.appendChild(boardElement);
        });
        const skipButton = document.createElement('button');
        skipButton.type = 'button';
        skipButton.classList.add('btn', 'btn-outline-danger', 'mt-3');
        skipButton.textContent = 'ないない';
        skipButton.addEventListener('click', loadRandomBoards);
        boardsContainer.appendChild(skipButton);
      })
      .catch(error => console.error('Error:', error));
  }

  function onBoardButtonClick(boardId) {
  fetch('/guest_majors', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    },
    body: JSON.stringify({ guest_major: { board_id: boardId } })
  })
  .then(response => response.json())
  .then(data => {
    loadRandomBoards();
  })
  .catch(error => console.error('Error:', error));
}

  document.addEventListener('click', function(event) {
    if (event.target.classList.contains('board-button')) {
      const boardId = event.target.dataset.boardId;
      onBoardButtonClick(boardId);
    }
  });
});