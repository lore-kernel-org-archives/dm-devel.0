From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Fix "dm kcopyd: Fix bug causing workqueue stalls"
 causes dead lock
Date: Wed, 9 Oct 2019 12:04:46 -0400
Message-ID: <20191009160446.GA2284@redhat.com>
References: <CAHSpA58dehDfou0ogCYnkziBt4oU5yo1SGHLhJb7vFKy9HhJPQ@mail.gmail.com>
	<db9a2b56-244b-1285-208c-14944f559f36@arrikto.com>
	<CAHSpA58H_Vuhub6Eqqmi2QZ2g4AAUX8KCCUMzMvyc87hDaVDKg@mail.gmail.com>
	<1b2b06a1-0b68-c265-e211-48273f26efaf@arrikto.com>
	<CAHSpA59rG7qhEDjtUUTNv5evyWHS_iTL0o8utRCr9MQvMDsEgw@mail.gmail.com>
	<e15bb4d9-d19b-f954-f71d-2985dd6e455a@arrikto.com>
	<20191009141308.GA1670@redhat.com>
	<d6aaebd8-ed3e-2e6a-14ea-33bf023ee4bb@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d6aaebd8-ed3e-2e6a-14ea-33bf023ee4bb@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, iliastsi@arrikto.com, agk@redhat.com, Guruswamy Basavaiah <guru2018@gmail.com>
List-Id: dm-devel.ids

On Wed, Oct 09 2019 at 11:44am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> On 10/9/19 5:13 PM, Mike Snitzer wrote:> On Tue, Oct 01 2019 at  8:43am -0400,
> > Nikos Tsironis <ntsironis@arrikto.com> wrote:
> > 
> >> On 10/1/19 3:27 PM, Guruswamy Basavaiah wrote:
> >>> Hello Nikos,
> >>>  Yes, issue is consistently reproducible with us, in a particular
> >>> set-up and test case.
> >>>  I will get the access to set-up next week, will try to test and let
> >>> you know the results before end of next week.
> >>>
> >>
> >> That sounds great!
> >>
> >> Thanks a lot,
> >> Nikos
> > 
> > Hi Guru,
> > 
> > Any chance you could try this fix that I've staged to send to Linus?
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=633b1613b2a49304743c18314bb6e6465c21fd8a
> > 
> > Shiort of that, Nikos: do you happen to have a test scenario that teases
> > out this deadlock?
> > 
> 
> Hi Mike,
> 
> Yes,
> 
> I created a 50G LV and took a snapshot of the same size:
> 
>   lvcreate -n data-lv -L50G testvg
>   lvcreate -n snap-lv -L50G -s testvg/data-lv
> 
> Then I ran the following fio job:
> 
> [global]
> randrepeat=1
> ioengine=libaio
> bs=1M
> size=6G
> offset_increment=6G
> numjobs=8
> direct=1
> iodepth=32
> group_reporting
> filename=/dev/testvg/data-lv
> 
> [test]
> rw=write
> timeout=180
> 
> , concurrently with the following script:
> 
> lvcreate -n dummy-lv -L1G testvg
> 
> while true
> do
>  lvcreate -n dummy-snap -L1M -s testvg/dummy-lv
>  lvremove -f testvg/dummy-snap
> done
> 
> This reproduced the deadlock for me. I also ran 'echo 30 >
> /proc/sys/kernel/hung_task_timeout_secs', to reduce the hung task
> timeout.
> 
> Nikos.

Very nice, well done.  Curious if you've tested with the fix I've staged
(see above)?  If so, does it resolve the deadlock?  If you've had
success I'd be happy to update the tags in the commit header to include
your Tested-by before sending it to Linus.  Also, any review of the
patch that you can do would be appreciated and with your formal
Reviewed-by reply would be welcomed and folded in too.

Mike
