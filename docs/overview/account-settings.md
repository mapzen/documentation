# Update your Mapzen account settings

When you signed in on Mapzen’s website, you can view and modify your account settings. These include changing your email address and password, and updating your credit card and billing information.

## Sign up for a Mapzen account

1. Go to https://mapzen.com.
2. Click `Sign Up`.
3. Choose your authentication method. Create your account by entering your e-mail address and password, or if you have a [GitHub](https://github.com) account, you can use it for authentication. GitHub is a website that enables people to collaborate on a project.

When you create an account, you need to agree to the Mapzen [Terms of Service](https://mapzen.com/terms/).

In the future when you sign in, use either your email address and password or GitHub account, depending on how you registered originally. If you forgot your password, you can also attempt to reset it.

## Change your email address or password

1. Sign in to your Mapzen account.
2. In the top corner of the page, click `Account` and click `Settings`.
3. If you are using an email address to sign in, you can update your email address and password. You can also update the name on your account.
4. With GitHub authentication, you can change your email address where you receive communications from Mapzen. Note that this is the address that was part of your GitHub profile when you originally authenticated your Mapzen account.

## Add your payment method

To use any of Mapzen’s services above the free limits, you need to add a payment method to your account.

If you do not have a valid credit card on file and you reach the free limits, your access to that Mapzen service will cease for the remainder of the month. You can continue to use other services up to their individual free limits.

At the end of each month, Mapzen calculates your usage and bill, and your charges are paid automatically by the credit card on file.

1. Sign in to your Mapzen account.
2. In the top corner of the page, click `Account` and click `Settings`.
3. In the `Billing` section, `Add Payment Method`.
4. Enter your credit card information.

If your account has any pending usage charges in a month, you can update it to a different credit card, but are unable to delete your credit card altogether until the balance has cleared.

To have details such as your mailing address or tax identification number appear on your monthly invoice, click `Update` under `Billing info`. All fields on the form are optional, so you can choose which ones you want to display on the invoice.

## Set monthly spending limits

You can set limits on your spending each month. This gives you the comfort of knowing that your bill will not exceed the amount you specify. You will only be charged for what you use, which may be less than the limit you set for the month.

To set a spending limit, you first need to add a payment method to your account. By default, there is no spending limit on your account, which means your usage (and potential bill) is unrestricted.

Limits can be changed at any time, but cannot be set to an amount lower than the already accrued charges for that month. After you change your limit, the monthly spending limit stays the same month after month into the future. You will be notified by email as you approach your spending limit.

The spending limit applies across all services. If you reach your spending limit by using only Mapzen Search, for example, you will not be able to use Mapzen Search or any other services beyond the free limits for the remainder of the month. Your account will not accumulate any charges for overages, but no results will be returned for your API requests. This means that your maps may no longer function.

Rate limits are reset on the first day of every month at 00:00 UTC (Coordinated Universal Time).

See https://mapzen.com/pricing for more information on current pricing and the limits available with the free plan.

1. Sign in to your Mapzen account.
2. In the top corner of the page, click `Account` and click `Settings`.
3. Make sure you have a payment method on your account. You will not see additional billing information unless you have a credit card on file.
4. In the `Billing` section, click `Update` under `Monthly spending limit`.
5. Make sure your billing status is `Enabled`.
6. Enter the maximum you want to spend across all Mapzen services.

As you approach your spending limit, your choices are to increase your spending limits, adjust your usage, or accept that your access to higher rate limits will end.

## Set your billing status

When billing is enabled, you have access to Mapzen services at levels above the free limits and are agreeing to pay for your usage, up to your monthly spending limit, if one exists. By default, billing is enabled when you add a payment method to your account.

To stop billing, set your billing status to disabled in the `Billing` section of your account settings. This has the effect of setting your monthly spending limit to $0 because you are only able to use Mapzen services up to the free limits of each product. If you exhaust the free limits, your maps may no longer function.

Any charges that were pending before you disabled billing will still be charged to the credit card on file at the end of the current billing cycle. However, no further charges can accrue. The billing status remains as you set it until you change it in the future.

Anytime you want to start billing again, set your billing status to `Enabled`.

## Enable premium support		

Premium support, which includes faster response times and a service-level agreement, is available for an additional [monthly fee](https://mapzen.com/pricing/#premium-support). You can add premium support even if you are within the free rate limits of Mapzen’s products.

When contacting Mapzen, users with premium support receive priority replies. Premium support benefits are available to anyone at your organization, not just an individual account.

A service-level agreement indicates the service's required uptime and instructions to take if these are not met. These are detailed in the Mapzen [Terms of Service](https://mapzen.com/terms/).

[Learn more about Mapzen support offerings](support)

You are billed for premium support at the beginning of each month. You can use it as soon as you enable it on your account, and the fee is prorated when joining in the middle of a billing cycle.

If you choose to disable your premium support access, you can continue to use your benefits through the end of the month and your credit card will not be charged in subsequent months. No refunds are issued for the remainder of the billing period.

_Note: Premium support is for assistance with Mapzen's hosted web services and does not include help for on-premises installations of Mapzen's open-source projects. If you need help running your own instance, there are [community-based options](support.md#github-and-community-chat)._

1. Sign in to your Mapzen account.		
2. In the top corner of the page, click `Account` and click `Settings`.		
3. Under `Support`, click `Enable` and agree to the terms.		
4. To end premium support, under `Support`, click `Update` and disable it on your account.

## Delete your Mapzen account

If you no longer want to have a Mapzen account, you can delete it permanently. When you do this, your API keys stop working almost immediately, which means any maps using them no longer function. You will lose access to your API keys, dashboard, and past usage data, and you will not be able to sign in again.

You can only delete your account if you have no outstanding charges.

_Tip: If you only need to update your name, email address, or billing information, you do not need to delete your account. You can change these in your account settings._

1. Sign in to your Mapzen account.
2. In the top corner of the page, click `Account` and click `Settings`.
3. Click `Delete your account`. If you do not see this section, your account has a balance due that must be paid before you can delete it.
4. Review what happens when you delete your account, and confirm that you want take this action.

If you are using GitHub authentication on your Mapzen account, optionally, sign into your GitHub account and revoke [Mapzen Platform](https://help.github.com/articles/reviewing-your-authorized-applications-oauth/) as an authorized application.

You may still continue to receive emails from Mapzen. If you want to unsubscribe, use the links in the newsletter email.
