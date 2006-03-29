From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Re: [PATCH] dm-striped device sizes must be multiple
	of chunk-size
Date: Wed, 29 Mar 2006 15:48:47 +0200
Message-ID: <20060329134847.GE3218@redhat.com>
References: <e3538fbd0603222128o525b4608h84b4004fc4ca0a61@mail.gmail.com>
	<200603242246.25314.kevcorry@us.ibm.com>
	<20060328120813.GB3218@redhat.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060328120813.GB3218@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Joseph Yasi <joe.yasi@gmail.com>
List-Id: dm-devel.ids


Kevin,

got a fix in a central location (activate.c) which looks like it cuts the issue.
Just waiting for metadata samples of reporters to get in to confirm.

Heinz

On Tue, Mar 28, 2006 at 02:08:13PM +0200, Heinz Mauelshagen wrote:
> 
> Kevin,
> 
> I'm not convinced that a more complex mapping is needed.
> 
> Haven't seen the reported case so far with a lot of RAID0 metadata samples
> users provided to me for various ATARAID flavours.
> 
> The RAID device size (which is smaller than the underlying device)
> needs to be divisable w/o rest by the stride size IMO.
> 
> Guess I'm missing something about setting up the device size (rd->sectors)
> correctly in the metadata format handler.
> 
> Investigating...
> 
> Heinz
> 
> On Fri, Mar 24, 2006 at 10:46:25PM -0600, Kevin Corry wrote:
> > On Wed March 22 2006 11:28 pm, Joseph Yasi wrote:
> > >     I am using the dmraid utility to detect and configure my Intel
> > > Software Raid RAID0 array.  When upgrading to 2.6.16 from 2.6.15, the
> > > system failed to boot because the device-mapper array was not built.
> > > I have traced the problem to this patch that limits dm-stripe to
> > > targets that are multiples of the chunk size.  I don't know whether to
> > > consider this a problem with device-mapper or with the Intel Software
> > > Raid BIOS that built the array.  Dmraid is giving me a target of
> > > 980460038 blocks with a chunk size of 256 blocks.  Is this a problem
> > > with device-mapper, the dmraid utility or the raid bios?  Should
> > > device-mapper handle striped targets that are not multiples of the
> > > chunk size?
> > 
> > Hmm...I obviously didn't expect dmraid to be creating such devices.
> > 
> > The kernel patch that was added to 2.6.16 is definitely correct. Dm-stripe 
> > should not allow creating a device with a size that's not a multiple of the 
> > chunk-size. To do so leaves a partial chunk at the end of each device. While 
> > at first glance this might not seem like a big deal, the striping 
> > calculations in the I/O path do not handle this situation (at least, not in 
> > the way you would think it should be handled), and cause I/O errors if you 
> > try to access the end of the stripe device.
> > 
> > > dmesg gives these pertinent lines:
> > > device-mapper: dm-stripe: Target length not divisible by chunk size.
> > > device-mapper: error adding target to table.
> > >
> > > dmsetup status
> > > isw_caejhbcidd_Volume03: 0 976173660 linear
> > > isw_caejhbcidd_Volume02: 0 4209030 linear
> > > isw_caejhbcidd_Volume01: 0 64197 linear
> > > isw_caejhbcidd_Volume0: 0 980460038 striped
> > >
> > > dmraid -s
> > > *** Group superset isw_caejhbcidd
> > > --> Active Subset
> > > name   : isw_caejhbcidd_Volume0
> > > size   : 980460038
> > > stride : 256
> > > type   : stripe
> > > status : ok
> > > subsets: 0
> > > devs   : 2
> > > spares : 0
> > 
> > In your example, your stripe device is 980460038 sectors, with a 256 sector 
> > chunk-size.This means the stripe device has 3829922 chunks, with 6 sectors 
> > left over (3 on each of the two devices, presumably). I would think that the 
> > BIOS intends that these last 3 sectors on each device should be striped with 
> > an effective chunk-size of 3 sectors. To do this, dmraid should set up a 
> > device with two targets, one with a chunk-size of 256, and one with a 
> > chunk-size of 3. The map would look something like:
> > 
> > 0 980460032 striped 2 256 /dev/hda 0 /dev/hdb 0
> > 980460032 6 striped 2 3 /dev/hda /dev/hdb 490230016
> > 
> > Unfortunately, this doesn't work either, because the chunk-size must be a 
> > power-of-2. So...since we know the second target in the map really represents 
> > only one "stripe", we could treat them as a concatenation of independent 
> > linear targets. So we end up with a map like this:
> > 
> > 0 980460032 striped 2 256 /dev/hda 0 /dev/hdb 0
> > 980460032 3 linear /dev/hda 490230016
> > 980460032 3 linear /dev/hdb 490230016
> > 
> > I'm thinking that this mapping would do what the BIOS is actually intending. 
> > It ought to be relatively straight-forward to recognize this situation in 
> > dmraid and set up a mapping similar to the one above.
> > 
> > -- 
> > Kevin Corry
> > kevcorry@us.ibm.com
> > http://www.ibm.com/linux/
> > http://evms.sourceforge.net/
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
