From: Brian Bunker <brian@purestorage.com>
Subject: Re: why doesn't multipathd use the device?
Date: Fri, 22 Jun 2012 10:00:48 -0700
Message-ID: <994E3EEC-8A44-4C18-9A2D-45B01F09FCFC@purestorage.com>
References: <A01D98BC-7342-4771-B139-F0A5F757D431@purestorage.com>
	<1340343876.27156.8.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340343876.27156.8.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

We are currently using multibus as a path_grouping_policy since all of our ports are active and there is no need to weight any different than others. The array is active / active.

In poking around the multipath source files I am assuming that this is what is happening in domap since that is the only path that returns a negative number to the caller in main.c in multipathd:

		if (lock_multipath(mpp, 1)) {
			condlog(3, "%s: failed to create map (in use)",
				mpp->alias);
			return DOMAP_RETRY;
		}

I guess that it didn't log since the log level of multipath was lower and that is why you want me to run at '-v 3'? If it is true that it believes that the map is in use what does that mean?

Thanks,
Brian

On Jun 21, 2012, at 10:44 PM, Christophe Varoqui wrote:

> On jeu., 2012-06-21 at 16:54 -0700, Brian Bunker wrote:
>> Hello everyone,
>> 
>> 
>> We have hit this problem a couple of times now on our RHEL 6.2
>> initiators using our FC target. We have many dm devices which should
>> have 4 paths to each. Sometimes we see that some of the dm devices do
>> not have the 4 paths. The underlying /dev/sd devices do exist but they
>> are not used by the dm device. Here is what I see:
>> 
>> 
>> mpathbbt (3624a9370f9b69331bb3d16650001000b) dm-11 PURE,FlashArray
>> size=500G features='0' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=1 status=active
>> |- 1:0:1:12 sds  65:32  active ready running
>> `- 1:0:0:12 sdae 65:224 active ready running
>> 
>> 
>> However there are devices for the remaining two paths they are just
>> not being used by multipathd:
>> 
>> 
>> /dev/sg18  1 0 1 12  0  /dev/sds  PURE      FlashArray        100 
>> /dev/sg30  1 0 0 12  0  /dev/sdae  PURE      FlashArray        100 
>> /dev/sg39  0 0 1 12  0  /dev/sdan  PURE      FlashArray        100 
>> /dev/sg48  0 0 0 12  0  /dev/sdaw  PURE      FlashArray        100
>> 
>> 
>> You can see by the LUN serial number that the devices do point to the
>> same LUN on the array. I am including just the LUN serial number, page
>> 0x80, in the interest of space page 0x83's NAA number also matches for
>> the 4 devices:
>> 
>> 
>> root@r13init31 ~]# sg_inq -p 0x80 /dev/sg18
>> VPD INQUIRY: Unit serial number page
>> Unit serial number: F9B69331BB3D16650001000B
>> 
>> 
>> [root@r13init31 ~]# sg_inq -p 0x80 /dev/sg30
>> VPD INQUIRY: Unit serial number page
>> Unit serial number: F9B69331BB3D16650001000B
>> 
>> 
>> [root@r13init31 ~]# sg_inq -p 0x80 /dev/sg39
>> VPD INQUIRY: Unit serial number page
>> Unit serial number: F9B69331BB3D16650001000B
>> 
>> 
>> [root@r13init31 ~]# sg_inq -p 0x80 /dev/sg48
>> VPD INQUIRY: Unit serial number page
>> Unit serial number: F9B69331BB3D16650001000B
> 
>> 
>> Any ideas why the paths are being rejected by domap?
>> 
> Have you tried the "group_by_serial" path grouping policy ?
> There might be funny side effects if the wwid discovered on paths is not
> the same though ...
> 
> Can you post the multipath -v3 output concerning those 4 paths
> discovery.
> 
> Regard,
> cvaroqui
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com
