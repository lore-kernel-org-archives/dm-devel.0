From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Fix "dm kcopyd: Fix bug causing workqueue stalls"
 causes dead lock
Date: Wed, 9 Oct 2019 10:13:08 -0400
Message-ID: <20191009141308.GA1670@redhat.com>
References: <CAHSpA58dehDfou0ogCYnkziBt4oU5yo1SGHLhJb7vFKy9HhJPQ@mail.gmail.com>
	<db9a2b56-244b-1285-208c-14944f559f36@arrikto.com>
	<CAHSpA58H_Vuhub6Eqqmi2QZ2g4AAUX8KCCUMzMvyc87hDaVDKg@mail.gmail.com>
	<1b2b06a1-0b68-c265-e211-48273f26efaf@arrikto.com>
	<CAHSpA59rG7qhEDjtUUTNv5evyWHS_iTL0o8utRCr9MQvMDsEgw@mail.gmail.com>
	<e15bb4d9-d19b-f954-f71d-2985dd6e455a@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e15bb4d9-d19b-f954-f71d-2985dd6e455a@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>, Guruswamy Basavaiah <guru2018@gmail.com>
Cc: dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Tue, Oct 01 2019 at  8:43am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> On 10/1/19 3:27 PM, Guruswamy Basavaiah wrote:
> > Hello Nikos,
> >  Yes, issue is consistently reproducible with us, in a particular
> > set-up and test case.
> >  I will get the access to set-up next week, will try to test and let
> > you know the results before end of next week.
> > 
> 
> That sounds great!
> 
> Thanks a lot,
> Nikos

Hi Guru,

Any chance you could try this fix that I've staged to send to Linus?
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=633b1613b2a49304743c18314bb6e6465c21fd8a

Shiort of that, Nikos: do you happen to have a test scenario that teases
out this deadlock?

Thanks,
Mike
