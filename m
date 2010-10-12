From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: raid0 and discard/trim - current state?
Date: Tue, 12 Oct 2010 16:57:39 -0400
Message-ID: <AANLkTinB+uM2oiW496U4Cu51pHPiW=ATvnG099GWf=-K@mail.gmail.com>
References: <4CB0A4B5.4010009@bakke.com> <4CB0B5B9.8070409@bakke.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CB0B5B9.8070409@bakke.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: DagB <dag@bakke.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Sat, Oct 9, 2010 at 2:34 PM, DagB <dag@bakke.com> wrote:
> On 10/09/2010 07:21 PM, DagB wrote:
>> Hi.
>>
>> I wonder about the current state of affairs regarding striping over
>> multiple SSDs.
>>
>> Found this thread:
>> http://marc.info/?t=126787186000002&r=1&w=2
>>
>> but nothing after that. Was this problem to hard to handle?
>>
>
> Bad form to reply to self.
>
> More googling finally turned up this commit:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8357422d4bf33bc2c35884d4016c3fc9efbbc1d2

To be clear: DM's striped target does support discards.  MD's raid0
(or any MD raid level) does not.
