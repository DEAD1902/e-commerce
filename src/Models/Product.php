<?php
declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    // Table name (optional if follows convention)
    protected $table = 'products';
    // Primary key (optional if 'id')
    protected $primaryKey = 'id';
    // Mass assignable attributes
    protected $fillable = [
        'name',
        'description',
        'price',
        'stock',
    ];

    // Disable timestamps if not used
    public $timestamps = false;
}
?>