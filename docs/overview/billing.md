# View your current usage and Mapzen Flex bill

When you are signed in with your Mapzen account, you can view your current usage and charges due.

[Mapzen Flex](https://mapzen.com/pricing) is Mapzen's pricing system, where you only pay for what you use. You can think of your Mapzen bill as similar to a home utility bill, where your charges are dependent on how much water or electricity, for example, you consumed in a month.

Because there are no paid tiers, you pay for each individual API request you make above the free rate limits. Although you may see pricing listed in units of 1,000, requests are not purchased in bundles. For example, $0.05 per 1,000 is intended to be a simpler way of representing that each request is $0.00005.

Billing is post-paid after the month ends, and there are no prepayment discounts available. There are no minimum fees for maintaining a Mapzen account, even if you have no usage for a while.

The billing currency is the United States Dollar (USD). Mapzen handles the payment of sales or usage tax that may be required in your area.

If you need to update your credit card information, you can do that from your profile settings page (??? link). If you have questions about your bill or are having problems paying it, please contact Mapzen at support@mapzen.com.

## View your usage

To check your usage, sign in to your developer account and review your dashboard.

1. Sign in to your Mapzen account.
2. In the top corner of the page, click `Account` and click `Dashboard`. This page shows your current Mapzen API keys.
3. Click one of your API keys in the list and click `Usage`. The graphs show the number of requests on this key for each product.

???
There is not currently an API for directly accessing your usage information, but you receive [HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) in the header for the server's response to your query.

After you make an API call to a Mapzen service, you can get more information in the HTTP headers of the response. HTTP headers are embedded metadata that tells your browser (or other software) how to make sense of the request.

X-ApiaxleProxy-Qpd-Left

???? Is this still valid? Is there a queries per month header? Does it list only free usage?

## Request a bill credit for service issues

_Note: This is only available to users who [subscribe to premium support](account-settings.md#Subscribe-to-premium-support-services), which includes a service-level agreement.)_

While Mapzen hopes you never experience an outage or downtime in services, you can request a credit in the event that issues occur. See your support agreement for more information about your rights and requirements, and keep in mind that those terms supersede any documentation content here.

1. If you are a premium support subscriber and believe that Mapzen has not met the uptime percentage in the developer agreement, record any information about the downtime you can, such as the service name and API, date and time, and estimated outage amount.
2. Within 15 days, send this to [Mapzen support](mailto:support@mapzen.com) for review.
