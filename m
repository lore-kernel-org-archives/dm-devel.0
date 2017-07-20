From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] dm-integrity: fix inefficient allocation of
 stack space
Date: Thu, 20 Jul 2017 11:43:11 -0400
Message-ID: <22896.53135.462550.221549@quad.stoffel.home>
References: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
	<22895.42876.199753.299282@quad.stoffel.home>
	<alpine.LRH.2.02.1707200622230.32226@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1707200622230.32226@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, John Stoffel <john@stoffel.org>, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> On Wed, 19 Jul 2017, John Stoffel wrote:

>> >>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
>> 
Mikulas> When using block size greater than 512 bytes, the dm-integrity target
Mikulas> allocates journal space inefficiently, it allocates one entry for each
Mikulas> 512-byte chunk of data, fills entries for each block of data and leaves
Mikulas> the remaining entries unused. This doesn't cause data corruption, but it
Mikulas> causes severe performance degradation.
>> 
Mikulas> This patch fixes the journal allocation. As a safety it also
Mikulas> adds BUG that fires if the variables representing journal
Mikulas> usage get out of sync (it's better to crash than continue and
Mikulas> corrupt data, so BUG is justified).
>> 
>> No, I don't agree.  You should lock down the block device(s) using the
>> dm-integrity target, but you should NOT take down the entire system
>> because of this.  Just return a failure up the stack that forces the
>> device into read only mode so that there's a chance to debug this
>> issue.
>> 
>> Using a BUG_ON, especially for code that isn't proven, is just wrong.
>> Do a WARN_ONCE() and then return an error instead.
>> 
>> John

Mikulas> That BUG can only be triggered by a bug in the code, it can't be triggered 
Mikulas> by bad data on the disk, so why should we write code to recover from it?

Because it's damn obnoxious to kill a system because of bad coding,
without giving the user a chance to recover or even investigate
the root cause.   If it's a bug in the code, just warn the user and
then try to continue.  If you can't continue, then just make the block
device go read-only to protect the data.

Again, why do you think BUG_ON is appropriate thing to do?  What
advantage does it have for you?

John
