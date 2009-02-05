From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 05 Feb 2009 17:44:59 +0000
Message-ID: <498B259B.5070703@redhat.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>	<498B00B3.5020402@redhat.com>
	<E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Moger, Babu wrote:
> Like Bryn said, you cannot have both MPP and device mapper together. MPP will be the first one to load. So it will claim all the devices.
> 
> I have modified your multipath.conf file. Please try this one below. 
> 
> devices {
>   device {
>                 vendor                  "DELL"
>                 product                 "MD3000i"

Are these actually correct? The -ll output the OP posted seemed to 
indicate his settings were being completely ignored (which usually 
suggests a vendor/product mismatch).

It would be good to get all the correct vendor/product details for the 
3000 models included upstream at some point so that users don't need 
to add their own device blocks.

Regards,
Bryn.
