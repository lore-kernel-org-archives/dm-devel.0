From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel oops with dm-cache
Date: Sun, 8 Dec 2013 22:13:05 -0500
Message-ID: <CAMM=eLcZdULJZaAfwct1Bnj4KjNxOBrBumeb_vM+PtdjErQ5fA@mail.gmail.com>
References: <20131208105930.GA3763@sesse.net>
	<20131208120152.GA4096@samfundet.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131208120152.GA4096@samfundet.no>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Sun, Dec 8, 2013 at 7:01 AM, Steinar H. Gunderson
<sgunderson@bigfoot.com> wrote:
> On Sun, Dec 08, 2013 at 11:59:30AM +0100, Steinar H. Gunderson wrote:
>> I woke up to my machine being crashed during the night; it complained about
>> the CPU being hung, but looking a bit closer in the CPU backtraces, it seems
>> that one of them had oopsed. I only have parts of this (it's salvaged from
>> the serial console), but hopefully it will help someone track it down:
>
> I booted, and within the hour it crashed again. This time I got the full
> oops:

This was fixed with this commit:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=47821767d26af4073fcfdfb3b96704f24a23416f

I'll be sending it to Linus at some point this coming week (along with
other DM fixes that are staged in the 'for-next' branch of
linux-dm.git).
