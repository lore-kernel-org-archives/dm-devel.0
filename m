From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 4.4-rc4 multipath not working?
Date: Fri, 11 Dec 2015 16:00:11 -0500
Message-ID: <20151211210010.GA28142@redhat.com>
References: <CAJtFHURrhfUqpqo8RLFRwJV55eAV68q62r71aHpvNH_J_Q=hLA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAJtFHURrhfUqpqo8RLFRwJV55eAV68q62r71aHpvNH_J_Q=hLA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: E V <eliventer@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 11 2015 at 12:23pm -0500,
E V <eliventer@gmail.com> wrote:

> Just tried booting 4.4-rc4 on a system with using the mptsas driver:
> LSISAS3008: FWVersion(03.00.08.00), ChipRevision(0x02), BiosVersion(05.07.02.00)
> 
> And multipath doesn't seem to be working, dmesg has lots of these:
> 
> device-mapper: table: 254:2: multipath: unknown path selector type
> device-mapper: ioctl: error adding target to table

You compile the path selector module you're attempting to use?
 
> Is it expected to work? and any suggestions on getting it to work,

Yes, no reason dm-multipath shouldn't work (other than user error).

Figure out what the multipath table load line that failed to load
(verbose logging with multipathd?) and make sure you have the
corresponding path selector modules enabled in your .config
