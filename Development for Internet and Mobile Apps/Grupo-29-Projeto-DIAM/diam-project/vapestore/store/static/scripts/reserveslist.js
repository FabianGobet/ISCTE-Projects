$(function () {
  
  const filterButtons = document.querySelectorAll('.filter-button');

// Loop through each filter button
filterButtons.forEach(function (button) {
  // Add a click event listener to the button
  button.addEventListener('click', function () {
    // Get the filter value for this button
    const filterValue = button.getAttribute('data-filter');

    // Get all table rows
    const tableRows = document.querySelectorAll('#items-table-body tr');

    // Loop through each row and show/hide based on the filter value
    tableRows.forEach(function (row) {
      const enviadoTd = row.querySelector('.pago');

      if (filterValue === 'all') {
        row.style.display = '';
      } else if (filterValue === 'pago') {
        if (enviadoTd && enviadoTd.textContent.trim() === 'Sim') {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      } else if (filterValue === 'nao-pago') {
        if (enviadoTd && enviadoTd.textContent.trim() === 'Nao') {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      }
    });
  });
});


});