// ProgressTracker class (needs to be defined first)
class ProgressTracker {
    constructor() {
        this.topics = {
            'Spacing Basics': { completed: 0, total: 3 },
            'Colors & Backgrounds': { completed: 0, total: 4 },
            'Typography': { completed: 0, total: 4 },
            'Transitions & Animation': { completed: 0, total: 4 },
            'Flexbox': { completed: 0, total: 5 },
            'CSS Grid': { completed: 0, total: 5 },
            'Responsive Design': { completed: 0, total: 5 },
            'Component Layouts': { completed: 0, total: 5 }
        };
        
        this.loadProgress();
    }
    
    loadProgress() {
        const savedProgress = localStorage.getItem('tailwindQuestProgress');
        if (savedProgress) {
            try {
                const progress = JSON.parse(savedProgress);
                for (const topic in progress) {
                    if (this.topics[topic]) {
                        this.topics[topic].completed = progress[topic].completed;
                    }
                }
            } catch (e) {
                console.error('Error loading progress:', e);
            }
        }
    }
    
    saveProgress() {
        localStorage.setItem('tailwindQuestProgress', JSON.stringify(this.topics));
    }
    
    completeChallenge(topic) {
        if (this.topics[topic] && this.topics[topic].completed < this.topics[topic].total) {
            this.topics[topic].completed++;
            this.saveProgress();
            return true;
        }
        return false;
    }
    
    getTopicProgress(topic) {
        return this.topics[topic] || { completed: 0, total: 0 };
    }
    
    getOverallProgress() {
        let completed = 0;
        let total = 0;
        
        for (const topic in this.topics) {
            completed += this.topics[topic].completed;
            total += this.topics[topic].total;
        }
        
        return total > 0 ? Math.round((completed / total) * 100) : 0;
    }
}

// Tailwind CSS Learning Game
class TailwindLearningGame {
    constructor() {
        this.currentLevel = 1;
        this.score = 0;
        this.completedChallenges = 0;
        this.conceptsLearned = 0;
        this.currentChallengeIndex = 0;
        this.learningPath = this.createLearningPath();
        this.currentTopic = 'Spacing Basics';
        this.selectedTopic = null;
        this.hintIndex = 0;
        
        // Initialize progress tracker
        this.progressTracker = new ProgressTracker();
        
        this.setupEventListeners();
        this.updateUI();
        
        // Only load challenge if we're on the game page
        if (document.getElementById('gameScreen')) {
            // Get topic from URL parameter
            const urlParams = new URLSearchParams(window.location.search);
            const topicFromUrl = urlParams.get('topic');
            
            if (topicFromUrl && this.learningPath[topicFromUrl]) {
                this.currentTopic = topicFromUrl;
            }
            
            this.loadCurrentChallenge();
        }
    }

    createLearningPath() {
    return {
        'Spacing Basics': {
            challenges: [
                { 
                    title: 'Add Padding', 
                    description: 'Add padding to all sides of the element.', 
                    instructions: 'Use a Tailwind class that starts with "p-" followed by a number to add padding of 1rem (16px) to all sides of the element.',
                    correctAnswer: 'p-4', 
                    targetClasses: 'p-4',
                    hints: [
                        "Think about which property controls internal spacing",
                        "Tailwind uses 'p' for padding followed by a size number",
                        "The number 4 corresponds to 1rem (16px) in Tailwind's spacing scale"
                    ],
                    explanation: {
                        title: 'Understanding Padding',
                        content: `
                            <p>Padding creates space inside an element, between its content and its border.</p>
                            <div class="class-explanation">
                                <h4>p-4</h4>
                                <p>The <code>p-4</code> class adds padding of 1rem (16px) to all sides of an element.</p>
                                <div class="class-example">
                                    p-4 = padding: 1rem;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box p-4 bg-blue-100">
                                    Content
                                </div>
                                <div class="text-sm text-center">
                                    The blue area represents padding
                                </div>
                            </div>
                            <p>Tailwind uses a spacing scale where:</p>
                            <ul class="list-disc pl-5 space-y-2">
                                <li><code>p-1</code> = 0.25rem (4px)</li>
                                <li><code>p-2</code> = 0.5rem (8px)</li>
                                <li><code>p-3</code> = 0.75rem (12px)</li>
                                <li><code>p-4</code> = 1rem (16px)</li>
                                <li><code>p-5</code> = 1.25rem (20px)</li>
                                <li><code>p-6</code> = 1.5rem (24px)</li>
                            </ul>
                        `
                    },
                    previewContent: 'Box content', 
                    previewClasses: 'bg-gray-200 text-gray-800 rounded' 
                },
                { 
                    title: 'Add Margin', 
                    description: 'Add margin to the top of the element.', 
                    instructions: 'Use a Tailwind class that starts with "mt-" followed by a number to add margin of 1rem to the top of the element.',
                    correctAnswer: 'mt-4', 
                    targetClasses: 'mt-4',
                    hints: [
                        "Margin creates space outside an element",
                        "Tailwind uses 'm' for margin followed by a direction letter",
                        "The letter 't' stands for top"
                    ],
                    explanation: {
                        title: 'Understanding Margin',
                        content: `
                            <p>Margin creates space outside an element, between it and other elements.</p>
                            <div class="class-explanation">
                                <h4>mt-4</h4>
                                <p>The <code>mt-4</code> class adds margin of 1rem (16px) to the top of an element.</p>
                                <div class="class-example">
                                    mt-4 = margin-top: 1rem;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box mt-4 bg-blue-100">
                                    Content
                                </div>
                                <div class="text-sm text-center">
                                    The space above represents margin
                                </div>
                            </div>
                            <p>Directional margin classes:</p>
                            <ul class="list-disc pl-5 space-y-2">
                                <li><code>mt-</code> = margin-top</li>
                                <li><code>mr-</code> = margin-right</li>
                                <li><code>mb-</code> = margin-bottom</li>
                                <li><code>ml-</code> = margin-left</li>
                                <li><code>mx-</code> = margin-left and margin-right</li>
                                <li><code>my-</code> = margin-top and margin-bottom</li>
                            </ul>
                        `
                    },
                    previewContent: 'Box content', 
                    previewClasses: 'bg-gray-200 text-gray-800 rounded' 
                },
                { 
                    title: 'Horizontal Padding', 
                    description: 'Add padding to the left and right sides.', 
                    instructions: 'Use a Tailwind class that starts with "px-" followed by a number to add padding to the left and right sides of the element.',
                    correctAnswer: 'px-4', 
                    targetClasses: 'px-4',
                    hints: [
                        "You need to add padding only to the left and right sides",
                        "Tailwind has special classes for horizontal spacing",
                        "The 'x' in px stands for the x-axis (left and right)"
                    ],
                    explanation: {
                        title: 'Understanding Horizontal Padding',
                        content: `
                            <p>Horizontal padding controls the spacing on both the left and right sides of an element.</p>
                            <div class="class-explanation">
                                <h4>px-4</h4>
                                <p>The <code>px-4</code> class adds padding of 1rem (16px) to both the left and right sides of an element.</p>
                                <div class="class-example">
                                    px-4 = padding-left: 1rem; padding-right: 1rem;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box px-4 bg-blue-100">
                                    Content
                                </div>
                                <div class="text-sm text-center">
                                    The blue areas on the sides represent horizontal padding
                                </div>
                            </div>
                            <p>Axis-based padding classes:</p>
                            <ul class="list-disc pl-5 space-y-2">
                                <li><code>px-</code> = padding-left and padding-right</li>
                                <li><code>py-</code> = padding-top and padding-bottom</li>
                            </ul>
                        `
                    },
                    previewContent: 'Box content', 
                    previewClasses: 'bg-gray-200 text-gray-800 rounded' 
                }
            ]
        },
        'Colors & Backgrounds': {
            challenges: [
                { 
                    title: 'Text Color', 
                    description: 'Change the text color to blue.', 
                    instructions: 'Use a Tailwind class that starts with "text-" followed by the color name and shade to make the text blue.',
                    correctAnswer: 'text-blue-500', 
                    targetClasses: 'text-blue-500',
                    hints: [
                        "Think about which property controls text color",
                        "Tailwind uses 'text-' prefix for text colors",
                        "Blue-500 is the default blue shade"
                    ],
                    explanation: {
                        title: 'Understanding Text Colors',
                        content: `
                            <p>Tailwind provides a comprehensive color system for styling text.</p>
                            <div class="class-explanation">
                                <h4>text-blue-500</h4>
                                <p>The <code>text-blue-500</code> class sets the text color to the default blue shade.</p>
                                <div class="class-example">
                                    text-blue-500 = color: #3B82F6;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box text-blue-500 p-4">
                                    Blue Text
                                </div>
                            </div>
                            <p>Tailwind's color system includes:</p>
                            <ul class="list-disc pl-5 space-y-2">
                                <li>9 color palettes (blue, red, green, etc.)</li>
                                <li>10 shades for each color (50, 100, 200, ..., 900)</li>
                                <li>500 is usually the default/base shade</li>
                            </ul>
                        `
                    },
                    previewContent: 'Colored text', 
                    previewClasses: 'bg-white rounded p-4' 
                },
                { 
                    title: 'Background Color', 
                    description: 'Change the background color to green.', 
                    instructions: 'Use a Tailwind class that starts with "bg-" followed by the color name and shade to make the background green.',
                    correctAnswer: 'bg-green-500', 
                    targetClasses: 'bg-green-500',
                    hints: [
                        "Think about which property controls background color",
                        "Tailwind uses 'bg-' prefix for background colors",
                        "Green-500 is the default green shade"
                    ],
                    explanation: {
                        title: 'Understanding Background Colors',
                        content: `
                            <p>Tailwind provides a comprehensive color system for styling backgrounds.</p>
                            <div class="class-explanation">
                                <h4>bg-green-500</h4>
                                <p>The <code>bg-green-500</code> class sets the background color to the default green shade.</p>
                                <div class="class-example">
                                    bg-green-500 = background-color: #10B981;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box bg-green-500 text-white p-4">
                                    Green Background
                                </div>
                            </div>
                            <p>Background color classes follow the pattern:</p>
                            <ul class="list-disc pl-5 space-y-2">
                                <li><code>bg-{color}-{shade}</code></li>
                                <li>Example: <code>bg-red-300</code>, <code>bg-purple-700</code></li>
                            </ul>
                        `
                    },
                    previewContent: 'Colored box', 
                    previewClasses: 'text-white rounded p-4' 
                }
            ]
        },
        'Typography': {
            challenges: [
                { 
                    title: 'Bold Text', 
                    description: 'Make the text bold using font-bold.', 
                    instructions: 'Use the Tailwind font utility that starts with "font-" followed by the weight descriptor to make the text bold.',
                    correctAnswer: 'font-bold', 
                    targetClasses: 'font-bold',
                    hints: [
                        "Think about font weight utilities",
                        "Tailwind uses 'font-' prefix for weights",
                        "font-bold applies bold styling"
                    ],
                    explanation: {
                        title: 'Understanding Font Weight',
                        content: `
                            <p>Font weight utilities in Tailwind let you control the thickness of text.</p>
                            <div class="class-explanation">
                                <h4>font-bold</h4>
                                <p>The <code>font-bold</code> class sets the text to bold (font-weight: 700).</p>
                                <div class="class-example">
                                    font-bold = font-weight: 700;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box font-bold p-4">
                                    Bold Text Example
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Bold text', 
                    previewClasses: 'bg-white rounded p-4' 
                },
                { 
                    title: 'Italic Text', 
                    description: 'Make the text italic using italic.', 
                    instructions: 'Use the Tailwind font style utility that simply states "italic" to make text italic.',
                    correctAnswer: 'italic', 
                    targetClasses: 'italic',
                    hints: [
                        "Think about font style",
                        "Tailwind uses the 'italic' class",
                        "Removes with 'not-italic'"
                    ],
                    explanation: {
                        title: 'Understanding Italic Text',
                        content: `
                            <p>Font style utilities in Tailwind allow toggling italic text.</p>
                            <div class="class-explanation">
                                <h4>italic</h4>
                                <p>The <code>italic</code> class applies italic font style.</p>
                                <div class="class-example">
                                    italic = font-style: italic;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box italic p-4">
                                    Italic Text Example
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Italic text', 
                    previewClasses: 'bg-white rounded p-4' 
                },
                { 
                    title: 'Large Text', 
                    description: 'Make the text large using text-2xl.', 
                    instructions: 'Use the Tailwind font size utility that starts with "text-" followed by a size descriptor to make text larger.',
                    correctAnswer: 'text-2xl', 
                    targetClasses: 'text-2xl',
                    hints: [
                        "Think about font size",
                        "Tailwind uses 'text-' prefix for sizes",
                        "text-2xl is bigger than text-base"
                    ],
                    explanation: {
                        title: 'Understanding Font Sizes',
                        content: `
                            <p>Tailwind provides many font size utilities.</p>
                            <div class="class-explanation">
                                <h4>text-2xl</h4>
                                <p>The <code>text-2xl</code> class sets font size to ~1.5rem (24px).</p>
                                <div class="class-example">
                                    text-2xl = font-size: 1.5rem; line-height: 2rem;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box text-2xl p-4">
                                    Large Text Example
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Large text', 
                    previewClasses: 'bg-white rounded p-4' 
                },
                { 
                    title: 'Underline Text', 
                    description: 'Underline the text using underline.', 
                    instructions: 'Use Tailwind decoration utilities that simply state "underline" to underline text.',
                    correctAnswer: 'underline', 
                    targetClasses: 'underline',
                    hints: [
                        "Think about text decoration",
                        "Tailwind has underline/overline/line-through",
                        "underline adds a line below text"
                    ],
                    explanation: {
                        title: 'Understanding Text Decoration',
                        content: `
                            <p>Tailwind provides utilities for underlining, overlining, or striking through text.</p>
                            <div class="class-explanation">
                                <h4>underline</h4>
                                <p>The <code>underline</code> class adds an underline to text.</p>
                                <div class="class-example">
                                    underline = text-decoration: underline;
                                </div>
                            </div>
                            <div class="visual-guide">
                                <div class="visual-box underline p-4">
                                    Underlined Text Example
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Underlined text', 
                    previewClasses: 'bg-white rounded p-4' 
                }
            ]
        },
        'Transitions & Animation': {
            challenges: [
                { 
                    title: 'Add Transition', 
                    description: 'Add a transition to the box using transition-all.', 
                    instructions: 'Use the Tailwind transition utility that starts with "transition-" followed by "all" to animate property changes.',
                    correctAnswer: 'transition-all', 
                    targetClasses: 'transition-all',
                    hints: [
                        "Think about enabling transitions",
                        "Tailwind uses 'transition-' prefix",
                        "transition-all applies to all properties"
                    ],
                    explanation: {
                        title: 'Understanding Transitions',
                        content: `
                            <p>Transition utilities allow smooth changes for CSS properties.</p>
                            <div class="class-explanation">
                                <h4>transition-all</h4>
                                <p>The <code>transition-all</code> class applies transitions to all properties.</p>
                                <div class="class-example">
                                    transition-all = transition-property: all;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Transition box', 
                    previewClasses: 'bg-white rounded p-4' 
                },
                { 
                    title: 'Add Duration', 
                    description: 'Set the transition duration to 500ms using duration-500.', 
                    instructions: 'Use the Tailwind duration utility that starts with "duration-" followed by a number to set timing.',
                    correctAnswer: 'duration-500', 
                    targetClasses: 'duration-500',
                    hints: [
                        "Think about transition timing",
                        "Tailwind uses 'duration-' prefix",
                        "duration-500 = 500ms"
                    ],
                    explanation: {
                        title: 'Understanding Transition Duration',
                        content: `
                            <p>Duration utilities define how long transitions take.</p>
                            <div class="class-explanation">
                                <h4>duration-500</h4>
                                <p>The <code>duration-500</code> class sets duration to 500ms.</p>
                                <div class="class-example">
                                    duration-500 = transition-duration: 500ms;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Duration box', 
                    previewClasses: 'bg-white rounded p-4 transition-all' 
                },
                { 
                    title: 'Add Hover Effect', 
                    description: 'Change background on hover using hover:bg-green-400.', 
                    instructions: 'Use the hover utility that starts with "hover:" followed by "bg-" and the color name to style hover states.',
                    correctAnswer: 'hover:bg-green-400', 
                    targetClasses: 'hover:bg-green-400',
                    hints: [
                        "Think about hover pseudo-class",
                        "Tailwind uses hover: prefix",
                        "hover:bg-green-400 changes background"
                    ],
                    explanation: {
                        title: 'Understanding Hover Utilities',
                        content: `
                            <p>Hover utilities apply styles when hovering over an element.</p>
                            <div class="class-explanation">
                                <h4>hover:bg-green-400</h4>
                                <p>The <code>hover:bg-green-400</code> class changes background color to green when hovered.</p>
                                <div class="class-example">
                                    hover:bg-green-400 = background-color: #4ADE80 on hover;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Hover me', 
                    previewClasses: 'bg-blue-400 rounded p-4 transition-all duration-500' 
                },
                { 
                    title: 'Add Animation', 
                    description: 'Add a bounce animation using animate-bounce.', 
                    instructions: 'Use the Tailwind animation utility that starts with "animate-" followed by the animation name to animate elements.',
                    correctAnswer: 'animate-bounce', 
                    targetClasses: 'animate-bounce',
                    hints: [
                        "Think about prebuilt animations",
                        "Tailwind uses animate- prefix",
                        "animate-bounce makes element bounce"
                    ],
                    explanation: {
                        title: 'Understanding Animations',
                        content: `
                            <p>Tailwind includes several pre-built animations like bounce, spin, ping, pulse.</p>
                            <div class="class-explanation">
                                <h4>animate-bounce</h4>
                                <p>The <code>animate-bounce</code> class makes the element bounce vertically.</p>
                                <div class="class-example">
                                    animate-bounce = keyframes bounce;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Bouncing box', 
                    previewClasses: 'bg-white rounded p-4' 
                }
            ]
        },
        'Flexbox': {
            challenges: [
                { 
                    title: 'Flex Container', 
                    description: 'Make the container a flexbox using flex.', 
                    instructions: 'Use the Tailwind class that simply states "flex" to enable flexbox layout.',
                    correctAnswer: 'flex', 
                    targetClasses: 'flex',
                    hints: [
                        "Think about display properties",
                        "Tailwind uses 'flex' for display: flex",
                        "Enables flexbox layout"
                    ],
                    explanation: {
                        title: 'Understanding Flexbox',
                        content: `
                            <p>The <code>flex</code> class in Tailwind turns an element into a flex container.</p>
                            <div class="class-explanation">
                                <h4>flex</h4>
                                <p>Enables flex layout, allowing flexible arrangement of children.</p>
                                <div class="class-example">
                                    flex = display: flex;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4' 
                },
                { 
                    title: 'Justify Center', 
                    description: 'Center items horizontally using justify-center.', 
                    instructions: 'Use the Tailwind class that starts with "justify-" followed by "center" to align items horizontally.',
                    correctAnswer: 'justify-center', 
                    targetClasses: 'justify-center',
                    hints: [
                        "Think about horizontal alignment",
                        "Tailwind uses 'justify-' prefix",
                        "justify-center centers content horizontally"
                    ],
                    explanation: {
                        title: 'Understanding Justify Content',
                        content: `
                            <p>The <code>justify-center</code> class centers flex items along the main axis.</p>
                            <div class="class-explanation">
                                <h4>justify-center</h4>
                                <p>Centers child elements horizontally in the flex container.</p>
                                <div class="class-example">
                                    justify-center = justify-content: center;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 flex' 
                },
                { 
                    title: 'Align Items Center', 
                    description: 'Center items vertically using items-center.', 
                    instructions: 'Use the Tailwind class that starts with "items-" followed by "center" to align items vertically.',
                    correctAnswer: 'items-center', 
                    targetClasses: 'items-center',
                    hints: [
                        "Think about vertical alignment",
                        "Tailwind uses 'items-' prefix",
                        "items-center aligns vertically"
                    ],
                    explanation: {
                        title: 'Understanding Align Items',
                        content: `
                            <p>The <code>items-center</code> class centers flex items along the cross axis.</p>
                            <div class="class-explanation">
                                <h4>items-center</h4>
                                <p>Centers child elements vertically in the flex container.</p>
                                <div class="class-example">
                                    items-center = align-items: center;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 flex' 
                },
                { 
                    title: 'Add Gap', 
                    description: 'Add space between items using gap-4.', 
                    instructions: 'Use the Tailwind class that starts with "gap-" followed by a number to add spacing between flex children.',
                    correctAnswer: 'gap-4', 
                    targetClasses: 'gap-4',
                    hints: [
                        "Think about spacing utilities",
                        "Tailwind uses 'gap-' prefix",
                        "gap-4 = 1rem space between items"
                    ],
                    explanation: {
                        title: 'Understanding Gaps',
                        content: `
                            <p>The <code>gap-4</code> class adds spacing between flex items.</p>
                            <div class="class-explanation">
                                <h4>gap-4</h4>
                                <p>Sets gap size to 1rem.</p>
                                <div class="class-example">
                                    gap-4 = gap: 1rem;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 rounded">Item 1</div><div class="bg-green-200 p-2 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 flex' 
                },
                { 
                    title: 'Wrap Items', 
                    description: 'Allow items to wrap using flex-wrap.', 
                    instructions: 'Use the Tailwind class that simply states "flex-wrap" to allow wrapping.',
                    correctAnswer: 'flex-wrap', 
                    targetClasses: 'flex-wrap',
                    hints: [
                        "Think about wrapping content",
                        "Tailwind uses flex-wrap utility",
                        "Allows items to wrap onto next line"
                    ],
                    explanation: {
                        title: 'Understanding Flex Wrap',
                        content: `
                            <p>The <code>flex-wrap</code> class lets flex items wrap into new lines when needed.</p>
                            <div class="class-explanation">
                                <h4>flex-wrap</h4>
                                <p>Prevents overflow and organizes items into multiple lines.</p>
                                <div class="class-example">
                                    flex-wrap = flex-wrap: wrap;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 rounded">Item 1</div><div class="bg-green-200 p-2 rounded">Item 2</div><div class="bg-red-200 p-2 rounded">Item 3</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 flex gap-4' 
                }
            ]
        },
        'CSS Grid': {
            challenges: [
                { 
                    title: 'Grid Container', 
                    description: 'Make the container a grid using grid.', 
                    instructions: 'Use the Tailwind class that simply states "grid" to enable grid layout.',
                    correctAnswer: 'grid', 
                    targetClasses: 'grid',
                    hints: [
                        "Think about display properties",
                        "Tailwind uses 'grid' for display: grid",
                        "Enables CSS grid layout"
                    ],
                    explanation: {
                        title: 'Understanding CSS Grid',
                        content: `
                            <p>The <code>grid</code> class in Tailwind turns an element into a grid container.</p>
                            <div class="class-explanation">
                                <h4>grid</h4>
                                <p>Enables grid layout for arranging children.</p>
                                <div class="class-example">
                                    grid = display: grid;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4' 
                },
                { 
                    title: 'Grid Columns', 
                    description: 'Create two columns using grid-cols-2.', 
                    instructions: 'Use the Tailwind class that starts with "grid-cols-" followed by a number to set the number of columns.',
                    correctAnswer: 'grid-cols-2', 
                    targetClasses: 'grid-cols-2',
                    hints: [
                        "Think about number of columns",
                        "Tailwind uses grid-cols-{n}",
                        "grid-cols-2 = 2 equal columns"
                    ],
                    explanation: {
                        title: 'Understanding Grid Columns',
                        content: `
                            <p>The <code>grid-cols-2</code> class creates two equal-width columns.</p>
                            <div class="class-explanation">
                                <h4>grid-cols-2</h4>
                                <p>Divides container into 2 equal parts.</p>
                                <div class="class-example">
                                    grid-cols-2 = grid-template-columns: repeat(2, minmax(0, 1fr));
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 grid' 
                },
                { 
                    title: 'Grid Gap', 
                    description: 'Add gap between grid items using gap-4.', 
                    instructions: 'Use the Tailwind class that starts with "gap-" followed by a number to add spacing between grid items.',
                    correctAnswer: 'gap-4', 
                    targetClasses: 'gap-4',
                    hints: [
                        "Think about spacing utilities",
                        "Tailwind uses 'gap-' prefix",
                        "gap-4 = 1rem spacing"
                    ],
                    explanation: {
                        title: 'Understanding Grid Gaps',
                        content: `
                            <p>The <code>gap-4</code> class adds spacing between grid items.</p>
                            <div class="class-explanation">
                                <h4>gap-4</h4>
                                <p>Sets gap between rows and columns.</p>
                                <div class="class-example">
                                    gap-4 = gap: 1rem;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 grid grid-cols-2' 
                },
                { 
                    title: 'Grid Row Span', 
                    description: 'Make an item span two rows using row-span-2.', 
                    instructions: 'Use the Tailwind class that starts with "row-span-" followed by a number to allow an item to span multiple rows.',
                    correctAnswer: 'row-span-2', 
                    targetClasses: 'row-span-2',
                    hints: [
                        "Think about spanning grid tracks",
                        "Tailwind uses row-span-{n}",
                        "row-span-2 spans across 2 rows"
                    ],
                    explanation: {
                        title: 'Understanding Grid Row Span',
                        content: `
                            <p>The <code>row-span-2</code> class lets an item take up 2 rows.</p>
                            <div class="class-explanation">
                                <h4>row-span-2</h4>
                                <p>Useful for creating masonry-like layouts.</p>
                                <div class="class-example">
                                    row-span-2 = grid-row: span 2 / span 2;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded row-span-2">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 grid grid-cols-2 gap-4' 
                },
                { 
                    title: 'Grid Column Start', 
                    description: 'Start an item at column 2 using col-start-2.', 
                    instructions: 'Use the Tailwind class that starts with "col-start-" followed by a number to position an item starting from a specific column.',
                    correctAnswer: 'col-start-2', 
                    targetClasses: 'col-start-2',
                    hints: [
                        "Think about positioning grid items",
                        "Tailwind uses col-start-{n}",
                        "col-start-2 starts item in column 2"
                    ],
                    explanation: {
                        title: 'Understanding Grid Column Start',
                        content: `
                            <p>The <code>col-start-2</code> class positions an item starting from the second column.</p>
                            <div class="class-explanation">
                                <h4>col-start-2</h4>
                                <p>Allows manual control over grid item placement.</p>
                                <div class="class-example">
                                    col-start-2 = grid-column-start: 2;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 m-1 rounded col-start-2">Item 1</div><div class="bg-green-200 p-2 m-1 rounded">Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 grid grid-cols-2 gap-4' 
                }
            ]
        },
        'Responsive Design': {
            challenges: [
                { 
                    title: 'Responsive Padding', 
                    description: 'Add responsive padding that changes on medium screens using md:p-6.', 
                    instructions: 'Use a Tailwind class that starts with "md:p-" followed by a number to apply padding at medium screens.',
                    correctAnswer: 'md:p-6', 
                    targetClasses: 'md:p-6',
                    hints: [
                        "Think about breakpoints",
                        "Tailwind uses prefixes like sm:, md:, lg:",
                        "md:p-6 applies padding at medium screens"
                    ],
                    explanation: {
                        title: 'Understanding Responsive Padding',
                        content: `
                            <p>Responsive utilities let you adjust styles at different screen sizes.</p>
                            <div class="class-explanation">
                                <h4>md:p-6</h4>
                                <p>Applies 1.5rem padding on medium screens (≥768px).</p>
                                <div class="class-example">
                                    md:p-6 = padding: 1.5rem on md+;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Responsive box', 
                    previewClasses: 'bg-gray-200 text-gray-800 rounded' 
                },
                { 
                    title: 'Responsive Text Size', 
                    description: 'Make text responsive using text-sm md:text-lg.', 
                    instructions: 'Use a Tailwind class that starts with "text-" followed by a size descriptor for default size, and "md:text-" for medium screens.',
                    correctAnswer: 'text-sm md:text-lg', 
                    targetClasses: 'text-sm md:text-lg',
                    hints: [
                        "Think about font size changes",
                        "Combine default + responsive prefix",
                        "text-sm on mobile, md:text-lg on medium screens"
                    ],
                    explanation: {
                        title: 'Understanding Responsive Text',
                        content: `
                            <p>Tailwind allows multiple utilities with breakpoints for responsive text.</p>
                            <div class="class-explanation">
                                <h4>text-sm md:text-lg</h4>
                                <p>Small text by default, larger text on md+ screens.</p>
                                <div class="class-example">
                                    text-sm = 0.875rem; md:text-lg = 1.125rem;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Responsive text', 
                    previewClasses: 'bg-gray-200 rounded p-4' 
                },
                { 
                    title: 'Responsive Grid', 
                    description: 'Create a responsive grid using grid grid-cols-1 md:grid-cols-2.', 
                    instructions: 'Use a Tailwind class that starts with "grid" followed by "grid-cols-1" for mobile and "md:grid-cols-2" for medium screens.',
                    correctAnswer: 'grid grid-cols-1 md:grid-cols-2', 
                    targetClasses: 'grid grid-cols-1 md:grid-cols-2',
                    hints: [
                        "Think about grid columns on different screens",
                        "grid-cols-1 for mobile",
                        "md:grid-cols-2 for medium screens"
                    ],
                    explanation: {
                        title: 'Understanding Responsive Grid',
                        content: `
                            <p>Responsive grid utilities let you adjust number of columns at breakpoints.</p>
                            <div class="class-explanation">
                                <h4>grid grid-cols-1 md:grid-cols-2</h4>
                                <p>One column by default, two columns on medium screens.</p>
                                <div class="class-example">
                                    grid-cols-1 = 1 col; md:grid-cols-2 = 2 cols;
                                </div>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 rounded">Grid Item 1</div><div class="bg-green-200 p-2 rounded">Grid Item 2</div>', 
                    previewClasses: 'bg-gray-100 rounded p-4 gap-4' 
                },
                { 
                    title: 'Hide on Mobile', 
                    description: 'Hide an element on mobile using hidden md:block.', 
                    instructions: 'Use the Tailwind class that simply states "hidden" for mobile and "md:block" to show on medium screens.',
                    correctAnswer: 'hidden md:block', 
                    targetClasses: 'hidden md:block',
                    hints: [
                        "Think about visibility",
                        "hidden removes from layout",
                        "md:block shows on medium screens"
                    ],
                    explanation: {
                        title: 'Understanding Visibility Utilities',
                        content: `
                            <p>You can hide or show elements based on screen size.</p>
                            <div class="class-explanation">
                                <h4>hidden md:block</h4>
                                <p>Element hidden on small screens, visible as block on medium+</p>
                                <div class="class-example">
                                    hidden = display: none; md:block = display: block;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Visible on md+', 
                    previewClasses: 'bg-gray-200 rounded p-4' 
                },
                {                     title: 'Show on Mobile', 
                    description: 'Show only on mobile using block md:hidden.', 
                    instructions: 'Use the Tailwind class that simply states "block" for mobile and "md:hidden" to hide on medium screens.',
                    correctAnswer: 'block md:hidden', 
                    targetClasses: 'block md:hidden',
                    hints: [
                        "Think about hiding on larger screens",
                        "block shows element by default",
                        "md:hidden hides on medium+ screens"
                    ],
                    explanation: {
                        title: 'Understanding Mobile Visibility',
                        content: `
                            <p>Reverse of the previous example: show only on mobile screens.</p>
                            <div class="class-explanation">
                                <h4>block md:hidden</h4>
                                <p>Visible on mobile, hidden on md+ screens.</p>
                                <div class="class-example">
                                    block = display: block; md:hidden = display: none;
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Visible on mobile', 
                    previewClasses: 'bg-gray-200 rounded p-4' 
                }
            ]
        },
        'Component Layouts': {
            challenges: [
                { 
                    title: 'Card Layout', 
                    description: 'Create a card using rounded-lg shadow-lg p-6.', 
                    instructions: 'Use Tailwind classes that start with "rounded-", "shadow-", and "p-" to style the box as a card.',
                    correctAnswer: 'rounded-lg shadow-lg p-6', 
                    targetClasses: 'rounded-lg shadow-lg p-6',
                    hints: [
                        "Think about rounded corners, shadows, padding",
                        "Combine multiple utilities",
                        "rounded-lg shadow-lg p-6 creates a card look"
                    ],
                    explanation: {
                        title: 'Understanding Card Layouts',
                        content: `
                            <p>Cards are built with rounded corners, shadows, and padding.</p>
                            <div class="class-explanation">
                                <h4>rounded-lg shadow-lg p-6</h4>
                                <p>This combo creates a simple card.</p>
                                <div class="class-example">
                                    rounded-lg = 0.5rem radius;<br>
                                    shadow-lg = large shadow;<br>
                                    p-6 = 1.5rem padding
                                </div>
                            </div>
                        `
                    },
                    previewContent: 'Card content', 
                    previewClasses: 'bg-white' 
                },
                { 
                    title: 'Navbar Flex', 
                    description: 'Make a navbar using flex justify-between items-center.', 
                    instructions: 'Use Tailwind classes that start with "flex", "justify-", and "items-" to align the logo and links.',
                    correctAnswer: 'flex justify-between items-center', 
                    targetClasses: 'flex justify-between items-center',
                    hints: [
                        "Think about horizontal navbars",
                        "Use justify-between for spacing",
                        "Use items-center for vertical alignment"
                    ],
                    explanation: {
                        title: 'Understanding Navbar Layout',
                        content: `
                            <p>A navbar is a flex container with logo and nav links.</p>
                            <div class="class-explanation">
                                <h4>flex justify-between items-center</h4>
                                <p>This centers items vertically and spreads them out horizontally.</p>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 rounded">Logo</div><div class="bg-green-200 p-2 rounded">Links</div>', 
                    previewClasses: 'bg-white flex justify-between items-center p-4' 
                },
                { 
                    title: 'Form Layout', 
                    description: 'Create a form layout using flex flex-col gap-4.', 
                    instructions: 'Use Tailwind classes that start with "flex", "flex-col", and "gap-" to stack form elements vertically with spacing.',
                    correctAnswer: 'flex flex-col gap-4', 
                    targetClasses: 'flex flex-col gap-4',
                    hints: [
                        "Think about vertical stacking",
                        "flex-col changes direction",
                        "gap-4 adds spacing"
                    ],
                    explanation: {
                        title: 'Understanding Form Layouts',
                        content: `
                            <p>Forms often need vertical stacking with gaps.</p>
                            <div class="class-explanation">
                                <h4>flex flex-col gap-4</h4>
                                <p>This stacks form elements vertically with spacing.</p>
                            </div>
                        `
                    },
                    previewContent: '<input class="border p-2 rounded mb-2" placeholder="Input" /><button class="bg-blue-500 text-white p-2 rounded">Submit</button>', 
                    previewClasses: 'bg-white flex flex-col gap-4 p-4' 
                },
                { 
                    title: 'Grid Cards', 
                    description: 'Display cards in a grid using grid grid-cols-2 gap-4.', 
                    instructions: 'Use Tailwind classes that start with "grid", "grid-cols-", and "gap-" to arrange cards in a grid layout.',
                    correctAnswer: 'grid grid-cols-2 gap-4', 
                    targetClasses: 'grid grid-cols-2 gap-4',
                    hints: [
                        "Think about multiple cards",
                        "Use grid-cols-2 for 2 columns",
                        "gap-4 for spacing"
                    ],
                    explanation: {
                        title: 'Understanding Grid Cards',
                        content: `
                            <p>Card grids are common in UI layouts.</p>
                            <div class="class-explanation">
                                <h4>grid grid-cols-2 gap-4</h4>
                                <p>Two column layout with spacing between items.</p>
                            </div>
                        `
                    },
                    previewContent: '<div class="bg-blue-200 p-2 rounded">Card 1</div><div class="bg-green-200 p-2 rounded">Card 2</div>', 
                    previewClasses: 'bg-white grid grid-cols-2 gap-4 p-4' 
                },
                { 
                    title: 'Footer Center', 
                    description: 'Center footer content using flex justify-center.', 
                    instructions: 'Use Tailwind classes that start with "flex" and "justify-" to center footer text horizontally.',
                    correctAnswer: 'flex justify-center', 
                    targetClasses: 'flex justify-center',
                    hints: [
                        "Think about centering content",
                        "flex makes container",
                        "justify-center centers horizontally"
                    ],
                    explanation: {
                        title: 'Understanding Footer Layout',
                        content: `
                            <p>Footers often have centered content.</p>
                            <div class="class-explanation">
                                <h4>flex justify-center</h4>
                                <p>This centers the footer text horizontally.</p>
                            </div>
                        `
                    },
                    previewContent: 'Footer', 
                    previewClasses: 'bg-white flex justify-center p-4' 
                }
            ]
        }
    };
}

                   

    setupEventListeners() {
        // Navigation - check if elements exist
        const startLearningBtn = document.getElementById('startLearningBtn');
        const quickStartBtn = document.getElementById('quickStartBtn');
        const backToHomeBtn = document.getElementById('backToHomeBtn');
        
        if (startLearningBtn) startLearningBtn.addEventListener('click', () => this.startLearning());
        if (quickStartBtn) quickStartBtn.addEventListener('click', () => this.quickStart());
        if (backToHomeBtn) backToHomeBtn.addEventListener('click', () => this.showHomeScreen());

        // Topic Selection - only on home page
        const topicCards = document.querySelectorAll('.topic-card');
        if (topicCards.length > 0) {
            topicCards.forEach(card => {
                card.addEventListener('click', () => this.selectTopic(card));
            });
        }

        // Challenge Controls - only on game page
        const checkAnswerBtn = document.getElementById('checkAnswerBtn');
        const hintBtn = document.getElementById('hintBtn');
        const nextChallengeBtn = document.getElementById('nextChallengeBtn');
        
        if (checkAnswerBtn) checkAnswerBtn.addEventListener('click', () => this.checkAnswer());
        if (hintBtn) hintBtn.addEventListener('click', () => this.showHint());
        if (nextChallengeBtn) nextChallengeBtn.addEventListener('click', () => this.nextChallenge());

        // Code Input - only on game page
        const codeInput = document.getElementById('codeInput');
        if (codeInput) {
            codeInput.addEventListener('input', (e) => this.updatePreview(e.target.value));
            codeInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') this.checkAnswer();
            });
        }

        // Explanation modal buttons
        const closeExplanation = document.getElementById('closeExplanation');
        const continueButton = document.getElementById('continueButton');
        
        if (closeExplanation) closeExplanation.addEventListener('click', () => this.hideExplanation());
        if (continueButton) continueButton.addEventListener('click', () => this.hideExplanation());
    }

    selectTopic(card) {
        // Remove selection from all cards
        document.querySelectorAll('.topic-card').forEach(c => {
            c.classList.remove('selected');
        });

        // Add selection to clicked card
        card.classList.add('selected');

        // Get the selected topic
        this.selectedTopic = card.getAttribute('data-topic');

        // Enable the start learning button
        const startBtn = document.getElementById('startLearningBtn');
        startBtn.disabled = false;
        startBtn.textContent = `🚀 Start Learning ${this.selectedTopic}`;
        startBtn.classList.remove('opacity-50', 'cursor-not-allowed');
    }

    startLearning() {
        if (!this.selectedTopic) {
            alert('Please select a topic first!');
            return;
        }

        this.currentTopic = this.selectedTopic;
        this.currentChallengeIndex = 0;
        
        // Redirect to game page with topic parameter
        window.location.href = `game.html?topic=${encodeURIComponent(this.selectedTopic)}`;
    }

    quickStart() {
        this.selectedTopic = 'Spacing Basics';
        this.currentTopic = 'Spacing Basics';
        this.currentChallengeIndex = 0;
        
        // Redirect to game page with topic parameter
        window.location.href = `game.html?topic=Spacing%20Basics`;
    }

    showGameScreen() {
        // This will be handled by page navigation
        document.getElementById('homeScreen').classList.add('hidden');
        document.getElementById('gameScreen').classList.remove('hidden');
        this.loadCurrentChallenge();
    }

    showHomeScreen() {
        // Redirect to home page with completion parameter
        window.location.href = `./topics.html?completed=true&topic=${encodeURIComponent(this.currentTopic)}`;
    }

    resetTopicSelection() {
        // Reset topic selection
        document.querySelectorAll('.topic-card').forEach(c => {
            c.classList.remove('selected');
        });
        
        this.selectedTopic = null;
        
        // Disable and reset start button
        const startBtn = document.getElementById('startLearningBtn');
        if (startBtn) {
            startBtn.disabled = true;
            startBtn.textContent = '🚀 Start Learning';
            startBtn.classList.add('opacity-50', 'cursor-not-allowed');
        }
    }

    loadCurrentChallenge() {
        const topic = this.currentTopic;
        const challenges = this.learningPath[topic].challenges;
        const challenge = challenges[this.currentChallengeIndex];

        document.getElementById('challengeTitle').textContent = challenge.title;
        document.getElementById('challengeDescription').textContent = challenge.description;
        document.getElementById('challengeInstructions').innerHTML = challenge.instructions;
        document.getElementById('currentTopic').textContent = topic;
        document.getElementById('codeInput').value = '';
        
        this.updatePreview('');
        this.updateTargetPreview();
        this.updateUI();
        
        // Reset hint index for new challenge
        this.hintIndex = 0;
    }

    updatePreview(inputValue) {
    const previewElement = document.getElementById('previewElement');
    const challenge = this.learningPath[this.currentTopic].challenges[this.currentChallengeIndex];
    
    // Combine classes and ensure minimum styling for visibility
    const allClasses = `preview-element-enhanced ${inputValue} ${challenge.previewClasses}`.trim();
    previewElement.className = allClasses;
    previewElement.innerHTML = challenge.previewContent;
    
    // Add visual feedback for better UX
    previewElement.style.transition = 'all 0.3s ease';
}

    updateTargetPreview() {
    const challenge = this.learningPath[this.currentTopic].challenges[this.currentChallengeIndex];
    const targetElement = document.getElementById('targetElement');
    
    if (targetElement) {
        const targetClasses = `preview-element-enhanced ${challenge.targetClasses} ${challenge.previewClasses}`.trim();
        targetElement.className = targetClasses;
        targetElement.innerHTML = challenge.previewContent;
    }
}

    checkAnswer() {
        const userInput = document.getElementById('codeInput').value.trim();
        const challenge = this.learningPath[this.currentTopic].challenges[this.currentChallengeIndex];
        
        if (userInput === challenge.correctAnswer) {
            this.handleCorrectAnswer(challenge);
        } else {
            this.handleIncorrectAnswer(challenge);
        }
    }

    handleCorrectAnswer(challenge) {
        this.score += 10;
        this.completedChallenges++;
        this.conceptsLearned++;
        
        // Update progress tracking
        this.progressTracker.completeChallenge(this.currentTopic);
        
        this.showSuccessMessage();
        document.getElementById('nextChallengeBtn').classList.remove('hidden');
        document.getElementById('checkAnswerBtn').classList.add('hidden');
        
        // Show explanation
        this.showExplanation(challenge);
        
        this.updateUI();
    }

    handleIncorrectAnswer(challenge) {
        this.showErrorMessage(`Try again!`);
    }

    showSuccessMessage() {
        // Visual feedback
        const codeInput = document.getElementById('codeInput');
        codeInput.style.border = '2px solid #10B981';
        codeInput.style.backgroundColor = 'rgba(16, 185, 129, 0.1)';
        
        setTimeout(() => {
            codeInput.style.border = '';
            codeInput.style.backgroundColor = '';
        }, 2000);
    }

    showErrorMessage(message) {
        // Visual feedback
        const codeInput = document.getElementById('codeInput');
        codeInput.style.border = '2px solid #EF4444';
        codeInput.style.backgroundColor = 'rgba(239, 68, 68, 0.1)';
        
        setTimeout(() => {
            codeInput.style.border = '';
            codeInput.style.backgroundColor = '';
        }, 2000);
    }

    showHint() {
        const challenge = this.learningPath[this.currentTopic].challenges[this.currentChallengeIndex];
        
        if (challenge.hints && challenge.hints.length > 0) {
            const hint = challenge.hints[this.hintIndex % challenge.hints.length];
            this.showMessage(`💡 Hint: ${hint}`, 'info');
            this.hintIndex++;
        } else {
            this.showMessage('No hints available for this challenge', 'info');
        }
    }
    
    showMessage(message, type) {
    // Remove any existing messages
    const existingMessages = document.querySelectorAll('.floating-message');
    existingMessages.forEach(msg => msg.remove());
    
    const messageEl = document.createElement('div');
    messageEl.className = `floating-message fixed top-4 right-4 px-4 py-3 rounded-lg shadow-lg z-50 font-semibold ${
        type === 'success' ? 'bg-green-500 text-white' : 
        type === 'error' ? 'bg-red-500 text-white' : 
        'hint-message'
    }`;
    
    // Add icon based on type
    const icon = type === 'success' ? '✅ ' : type === 'error' ? '❌ ' : '💡 ';
    messageEl.innerHTML = icon + message;
    
    document.body.appendChild(messageEl);
    
    setTimeout(() => {
        messageEl.style.opacity = '0';
        messageEl.style.transform = 'translateX(100%)';
        setTimeout(() => messageEl.remove(), 300);
    }, type === 'info' ? 4000 : 3000);
}

    showExplanation(challenge) {
        const modal = document.getElementById('explanationModal');
        const content = document.getElementById('explanationContent');
        
        content.innerHTML = challenge.explanation.content;
        document.querySelector('.explanation-header h2').textContent = challenge.explanation.title;
        
        modal.classList.remove('hidden');
    }

    hideExplanation() {
        document.getElementById('explanationModal').classList.add('hidden');
    }

    nextChallenge() {
        const topic = this.learningPath[this.currentTopic];
        
        // Reset hint index
        this.hintIndex = 0;
        
        if (this.currentChallengeIndex < topic.challenges.length - 1) {
            // Move to next challenge in current topic
            this.currentChallengeIndex++;
            this.loadCurrentChallenge();
        } else {
            // Topic completed - show completion message
            this.showTopicCompleted();
        }
        
        document.getElementById('nextChallengeBtn').classList.add('hidden');
        document.getElementById('checkAnswerBtn').classList.remove('hidden');
    }

    showTopicCompleted() {
        const learningArea = document.getElementById('learningArea');
        const topicProgress = this.progressTracker.getTopicProgress(this.currentTopic);
        
        learningArea.innerHTML = `
            <div class="text-center">
                <h3 class="text-3xl font-bold mb-4">🎉 Topic Completed!</h3>
                <p class="text-xl text-gray-300 mb-6">You've mastered ${this.currentTopic}!</p>
                <div class="bg-quest-primary/20 rounded-lg p-6 mb-6">
                    <h4 class="text-xl font-bold mb-4">Topic Stats:</h4>
                    <div class="grid grid-cols-2 gap-4 text-left">
                        <div>Score: <span class="font-bold text-quest-accent">${this.score}</span></div>
                        <div>Challenges: <span class="font-bold text-quest-secondary">${this.completedChallenges}</span></div>
                        <div>Concepts: <span class="font-bold text-quest-primary">${this.conceptsLearned}</span></div>
                        <div>Level: <span class="font-bold text-purple-400">${this.currentLevel}</span></div>
                        <div>Progress: <span class="font-bold text-quest-accent">${topicProgress.completed}/${topicProgress.total}</span></div>
                    </div>
                </div>
                <div class="flex justify-center space-x-4">
                    <button id="playAgainBtn" class="bg-quest-secondary hover:bg-green-600 text-white font-bold py-3 px-6 rounded-lg transition-colors">
                        Play Again
                    </button>
                    <button id="chooseTopicBtn" class="bg-quest-primary hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-lg transition-colors">
                        Choose Another Topic
                    </button>
                </div>
            </div>
        `;

        // Add event listeners to the new buttons
        document.getElementById('playAgainBtn').addEventListener('click', () => {
            this.currentChallengeIndex = 0;
            this.loadCurrentChallenge();
            document.getElementById('nextChallengeBtn').classList.add('hidden');
            document.getElementById('checkAnswerBtn').classList.remove('hidden');
        });

        document.getElementById('chooseTopicBtn').addEventListener('click', () => {
            this.showHomeScreen();
        });
    }

    updateUI() {
        // Update home screen stats
        const levelElement = document.getElementById('level');
        const scoreElement = document.getElementById('score');
        const conceptsElement = document.getElementById('concepts');
        
        if (levelElement) levelElement.textContent = this.currentLevel;
        if (scoreElement) scoreElement.textContent = this.score;
        if (conceptsElement) conceptsElement.textContent = this.conceptsLearned;
        
        // Update game screen stats
        const gameLevelElement = document.getElementById('gameLevel');
        const gameScoreElement = document.getElementById('gameScore');
        const completedChallengesElement = document.getElementById('completedChallenges');
        const conceptsLearnedElement = document.getElementById('conceptsLearned');
        
        if (gameLevelElement) gameLevelElement.textContent = this.currentLevel;
        if (gameScoreElement) gameScoreElement.textContent = this.score;
        if (completedChallengesElement) completedChallengesElement.textContent = this.completedChallenges;
        if (conceptsLearnedElement) conceptsLearnedElement.textContent = this.conceptsLearned;
        
        // Calculate progress for current topic using ProgressTracker
        const topicProgress = this.progressTracker.getTopicProgress(this.currentTopic);
        const progress = topicProgress.total > 0 ? Math.round((topicProgress.completed / topicProgress.total) * 100) : 0;
        const progressElement = document.getElementById('progress');
        const overallProgressElement = document.getElementById('overallProgress');
        const progressBar = document.getElementById('progressBar');
        if (progressElement) progressElement.textContent = progress + '%';
        if (overallProgressElement) overallProgressElement.textContent = progress + '%';
        if (progressBar) progressBar.style.width = progress + '%';
        
        // Calculate accuracy (simplified)
        const accuracy = this.completedChallenges > 0 ? Math.round((this.completedChallenges / (this.completedChallenges + 2)) * 100) : 0;
        const accuracyElement = document.getElementById('accuracy');
        if (accuracyElement) accuracyElement.textContent = accuracy + '%';
    }
}

// Tutorial Manager
class TutorialManager {
    constructor(game) {
        this.game = game;
        this.currentStep = 0;

        // Steps for tutorial: can add more as needed
        this.steps = [
            {
                title: "Welcome to Tailwind Quest!",
                text: "In this game, you'll learn Tailwind CSS by completing coding challenges.",
                highlight: null
            },
            {
                title: "Before We Start",
                text: "We recommend you have a basic understanding of HTML and CSS. If you're new, consider checking out our blog post on getting started with those topics.",
                highlight: null
            },
            {
                title: "Code Editor",
                text: "Here's where you type Tailwind classes. Try applying the correct ones to solve challenges.",
                highlight: "#codeEditor"
            },
            {
                title: "Target Area",
                text: "This shows what your code should look like once styled correctly.",
                highlight: "#targetContainer"
            },
            {
                title: "Live Preview",
                text: "As you type in the editor, your work will be rendered here in real time.",
                highlight: "#previewContainer"
            },
            {
                title: "Achievements",
                text: "Earn badges like 'Speedrunner' or 'Perfect Score' for extra challenges!",
                highlight: "#achievementsContainer"
            },
            {
                title: "Progress Bar",
                text: "Track your learning progress in the following topic here.",
                highlight: "#overallProgressSection"
            },
            {
                title: "Need Help?",
                text: "Click the chat icon anytime for hints or explanations.",
                highlight: "#chatBotFakeOverlay"
            },
            {
                title: "You're Ready!",
                text: "That's it! Time to start learning Tailwind. Good luck!",
                highlight: null
            }
        ];

        this.overlay = document.getElementById("tutorialOverlay");
        this.title = document.getElementById("tutorialTitle");
        this.text = document.getElementById("tutorialText");
        this.nextBtn = document.getElementById("tutorialNext");
        this.prevBtn = document.getElementById("tutorialPrev");
        this.skipBtn = document.getElementById("tutorialSkip");
        this.currentStepEl = document.getElementById("tutorialCurrentStep");
        this.totalStepsEl = document.getElementById("tutorialTotalSteps");

        if (this.overlay && this.nextBtn && this.skipBtn) {
            this.nextBtn.addEventListener("click", () => this.nextStep());
            this.prevBtn.addEventListener("click", () => this.prevStep());
            this.skipBtn.addEventListener("click", () => this.endTutorial());
        }
        
        // Set total steps
        if (this.totalStepsEl) {
            this.totalStepsEl.textContent = this.steps.length;
        }
    }

    start() {
        this.currentStep = 0;
        this.showStep();
        this.overlay.classList.remove("hidden");
    }

    showStep() {
        const step = this.steps[this.currentStep];
        if (!step) return this.endTutorial();

        this.title.textContent = step.title;
        this.text.textContent = step.text;
        
        // Update step counter
        if (this.currentStepEl) {
            this.currentStepEl.textContent = this.currentStep + 1;
        }
        
        // Update button states
        if (this.prevBtn) {
            this.prevBtn.disabled = this.currentStep === 0;
        }
        if (this.nextBtn) {
            this.nextBtn.textContent = this.currentStep === this.steps.length - 1 ? "Finish" : "Next";
        }

        // Remove previous highlight
        document.querySelectorAll(".tutorial-highlight").forEach(el => {
            el.classList.remove("ring-4", "ring-purple-400", "ring-offset-2", "tutorial-highlight", "shadow-[0_0_2000px_2500px_rgba(0,0,0,0.5)]", "z-9999");
        });

        // Highlight new element if exists
        if (step.highlight) {
            const el = document.querySelector(step.highlight);
            if (el) {
                el.classList.add("ring-4",
                                "ring-purple-400",
                                "ring-offset-2",
                                "tutorial-highlight", 
                                "shadow-[0_0_2000px_2500px_rgba(0,0,0,0.5)]",
                                "z-9999"
                                );
                
                // Scroll to the element
                el.scrollIntoView({
                    behavior: "smooth",
                    block: "center",
                    inline: "nearest"
                });
            }
        }
    }

    nextStep() {
        this.currentStep++;
        if (this.currentStep >= this.steps.length) {
            this.endTutorial();
        } else {
            this.showStep();
        }
    }
    
    prevStep() {
        if (this.currentStep > 0) {
            this.currentStep--;
            this.showStep();
        }
    }

    endTutorial() {
        this.overlay.classList.add("hidden");
        // Remove highlight if any left
        document.querySelectorAll(".tutorial-highlight").forEach(el => {
            el.classList.remove("ring-4", "ring-yellow-400", "ring-offset-2", "tutorial-highlight");
        });
    }
}

// Initialize tutorial when page loads
document.addEventListener('DOMContentLoaded', () => {
    // Your existing game initialization
    window.game = new TailwindLearningGame();
    
    // Initialize tutorial
    window.tutorial = new TutorialManager(window.game);

    // Show tutorial if overall progress = 0% and not shown this session
    const progressTracker = window.game.progressTracker;
    const overallProgress = progressTracker.getOverallProgress();

    if (overallProgress === 0 && !sessionStorage.getItem("tutorialShown")) {
        // Small delay to ensure DOM is fully rendered
        setTimeout(() => {
            window.tutorial.start();
            sessionStorage.setItem("tutorialShown", "true");
        }, 500);
    }
    
    // Add click event to tutorial button if you have one
    const tutorialBtn = document.getElementById('tutorialBtn');
    if (tutorialBtn) {
        tutorialBtn.addEventListener('click', () => {
            window.tutorial.start();
        });
    }
});