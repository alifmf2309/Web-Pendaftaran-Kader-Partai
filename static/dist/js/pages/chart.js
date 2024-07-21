<script>
    document.addEventListener('DOMContentLoaded', function() {
        var ctx = document.getElementById('myChart').getContext('2d');
        var myChart = new Chart(ctx, {
            type: 'doughnut', // Jenis chart (misalnya doughnut, bar, pie, dll.)
            data: {
                labels: ['Label 1', 'Label 2', 'Label 3'], // Label untuk setiap bagian diagram
                datasets: [{
                    label: 'Diagram Persen',
                    data: [30, 50, 20], // Data persentase untuk masing-masing bagian
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.6)', // Warna untuk setiap bagian
                        'rgba(54, 162, 235, 0.6)',
                        'rgba(255, 206, 86, 0.6)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)', // Warna border untuk setiap bagian
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                legend: {
                    position: 'bottom' // Posisi legenda (top, bottom, left, right)
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var dataset = data.datasets[tooltipItem.datasetIndex];
                            var total = dataset.data.reduce(function(previousValue, currentValue, currentIndex, array) {
                                return previousValue + currentValue;
                            });
                            var currentValue = dataset.data[tooltipItem.index];
                            var percentage = Math.floor(((currentValue / total) * 100) + 0.5);
                            return percentage + '%';
                        }
                    }
                }
            }
        });
    });
</script>
