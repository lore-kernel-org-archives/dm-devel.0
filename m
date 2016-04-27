From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [4.4, 4.5,
 4.6] Regression: encrypted swap (dm-crypt) freezes system while
 under memory pressure and swapping
Date: Wed, 27 Apr 2016 17:13:24 +0200
Message-ID: <5720D714.9010504@redhat.com>
References: <26e0640c-40b0-5121-5d85-727d4fef82c5@binary-island.eu>
	<f42fde0f-fb4c-89a5-6199-bf7dd42c97d0@binary-island.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f42fde0f-fb4c-89a5-6199-bf7dd42c97d0@binary-island.eu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matthias Dahl <ml_linux-dm-devel@binary-island.eu>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/27/2016 02:44 PM, Matthias Dahl wrote:
> Hello @all,
>
> since I haven't seen any replies to this so far, is there anything else
> I can do to help track this bug down?
>
> I have posted the original message to both the lkml as well as dm-devel
> lists, by the way, without much luck. ;-)
>
> Thanks in advance -- and sorry for kind of re-posting the issue.
>
> So long,
> Matthias
>

Hi Matthias,

I observe that putting swap on top of dm-crypt (tested in current 4.6-rc 
kernel) have some unexpected side effects. Most notably it seems to me 
that oom killer joins the party quite prematurely even when there 
remains plenty of free swap space (almost all). But I didn't experience 
any permanent system freeze or crash. Just, let us dig deeper for a while...

Thank you for the report!

O.
