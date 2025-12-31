import 'package:flutter/material.dart';
import 'package:eco_kitchen/screens/evaluate.dart';

const Color primaryGreen = Color(0xFF9DB67B);
const Color secondaryGreen = Color(0xFFE4EEE1);
const Color lightGreen = Color(0xFFF5F8F3);

class RecipeReviewsScreen extends StatelessWidget {
  final String recipeTitle;
  final String recipeImage;

  const RecipeReviewsScreen({
    Key? key,
    required this.recipeTitle,
    required this.recipeImage,
  }) : super(key: key);

  // Sample reviews data
  static final List<Map<String, dynamic>> _reviews = [
    {
      'username': '@r_joshua',
      'avatar': 'assets/images/meal.png',
      'time': '15 Mins Ago',
      'comment':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu.',
      'rating': 4,
    },
    {
      'username': '@josh-ryan',
      'avatar': 'assets/images/meal.png',
      'time': '40 Mins Ago',
      'comment':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu.',
      'rating': 3,
    },
    {
      'username': '@sweet.sarah',
      'avatar': 'assets/images/meal.png',
      'time': '1 Hr Ago',
      'comment':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla eleifend purus vel dignissim. Praesent urna ante, iaculis at lobortis eu.',
      'rating': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),

                // Header with back button and title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: primaryGreen,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                ),

                SizedBox(height: 24),

                // Recipe card with image and info
                Container(
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Recipe image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.asset(
                            recipeImage,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Recipe info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  recipeTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    ...List.generate(
                                        3,
                                        (index) => Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 16,
                                            )),
                                    Icon(
                                      Icons.star_border,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '(456 Reviews)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EvaluateScreen(
                                          recipeTitle: recipeTitle,
                                          recipeImage: recipeImage,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'Add Review',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: primaryGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Comments section
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryGreen,
                  ),
                ),

                SizedBox(height: 16),

                // Reviews list
                ...List.generate(_reviews.length, (index) {
                  final review = _reviews[index];
                  return _buildReviewCard(review);
                }),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              // Avatar
              ClipOval(
                child: Image.asset(
                  review['avatar'],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              // Username
              Text(
                review['username'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              // Time
              Text(
                '(${review['time']})',
                style: TextStyle(
                  fontSize: 13,
                  color: primaryGreen,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Comment text
          Text(
            review['comment'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          SizedBox(height: 12),

          // Star rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review['rating'] ? Icons.star : Icons.star_border,
                color: primaryGreen,
                size: 22,
              );
            }),
          ),
        ],
      ),
    );
  }
}
