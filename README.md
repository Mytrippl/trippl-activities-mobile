# Trippl Activities Mobile

Mobile-side activity and attraction search, availability, pricing, traveler eligibility, ratings, cancellation, duration, and guide-language components used within Mytrippl.

This repository contains the custom Dart layer supporting Mytrippl's activities and attractions experience. It prepares availability searches, processes traveler age requirements, interprets activity pricing models, transforms ratings and attraction information into presentation-ready states, and handles cancellation, duration, and guide-language information.

## Core Capabilities

### Activity Search

Custom utilities prepare activity information for search and discovery within the mobile application.

The module includes:

- Activity search-type handling
- Activity option presentation
- Availability search preparation
- Guest-aware search data
- Activity result presentation

This provides a consistent processing layer between the application interface and activity inventory services.

### Availability Processing

Activity inventory can depend on date, option, and traveler composition.

The module prepares structured availability requests using the information selected in the mobile experience, allowing activity options and traveler requirements to be passed into the availability flow consistently.

### Traveler Age Bands

Activities can apply different eligibility and pricing rules according to traveler age.

Custom utilities handle:

- Activity age bands
- Traveler count calculation
- Guest classification
- Age-aware availability data

This allows traveler information from Mytrippl to be converted into structures suitable for activity searches and availability checks.

### Activity Pricing

Different activities can expose different pricing structures.

Supporting logic includes:

- Pricing-type interpretation
- Activity price presentation
- Attraction price-level presentation
- Price-level normalization
- Presentation-ready pricing states

### Ratings

Raw rating information is converted into consistent values and visual states for the mobile interface.

The module includes:

- Activity rating normalization
- Rating-value processing
- Rating-box visual states
- Attraction rating presentation

### Attraction Information

Activity results can include contextual information about the attraction or experience.

Supporting utilities handle:

- Attraction distance presentation
- Attraction price levels
- Activity option names
- Search-result context

### Cancellation Policies

Cancellation information is transformed into concise presentation states that can be displayed within activity details and booking flows.

Custom logic summarizes activity cancellation conditions without requiring individual interface components to interpret raw policy data directly.

### Duration Presentation

Activity duration data can arrive in different formats depending on the underlying experience.

The mobile layer normalizes this information into consistent duration summaries for presentation throughout the activity experience.

### Guide Languages

Activities can provide guides or experiences in one or more supported languages.

The module handles:

- Guide-language data
- Guide-language presentation
- Language titles
- Consistent language information across activity options

### Activity Result Processing

Activity search results can be processed before presentation using dedicated filtering and sorting utilities.

Results can be filtered using:

- Minimum and maximum price
- Minimum rating
- Free-cancellation availability
- Instant confirmation
- Minimum and maximum duration
- Guide language
- Current bookability

Results can also be ordered by price, rating, review count, and duration while preserving the original provider ordering when recommended sorting is selected.

### Pricing and Availability Processing

Pricing utilities normalize different activity pricing structures, including per-person and per-group pricing. They calculate traveler-adjusted totals and expose original pricing and discount information when available.

Availability processing evaluates bookability, remaining capacity, available time slots, requested traveler counts, and the earliest available time.

### Traveler Validation

Traveler validation maps passenger ages against activity age bands and checks:

- Minimum traveler requirements
- Maximum traveler requirements
- Supported age ranges
- Traveler category assignment
- Unsupported traveler ages

This allows invalid traveler combinations to be identified before an availability or booking request is prepared.

### Search Request Construction

The activity search request layer normalizes:

- Destination and product identifiers
- Travel dates
- Adult, child, and infant counts
- Currency and language
- Pagination
- Price and rating filters
- Free-cancellation preferences

Optional and empty values are omitted from generated request payloads.

## Repository Structure

```text
lib/
└── custom_code/
    └── functions/
        └── Search, availability, traveler, pricing, rating, cancellation, duration, and guide-language logic
```

## Technology

The implementation is written in Dart for the Flutter-based Mytrippl mobile application.

The custom-code layer works with Mytrippl's activity search models, traveler information, availability data, pricing structures, application state, and generated Flutter components.

## Architecture

This repository represents the mobile processing and presentation layer of Mytrippl's activities experience.

Activity inventory, availability, product details, and booking services are supplied separately through backend and external integrations. This module focuses on converting those structures into states that can be used consistently by the mobile interface.

## Project Context

Mytrippl integrates activities and attractions alongside flights, hotels, transport, eSIMs, and other travel services.

This repository isolates the custom mobile engineering responsible for activity discovery, availability, traveler requirements, pricing, ratings, cancellation information, and experience presentation from the larger Mytrippl application codebase.
