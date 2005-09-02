From: Steve Lord <lord@xfs.org>
Subject: Re: FW: How to avoid lots of read ios to passive paths
	of	active-pass ive storage devices?
Date: Fri, 02 Sep 2005 10:34:35 -0500
Message-ID: <4318710B.6060904@xfs.org>
References: <C2EEB4E538D3DC48BF57F391F422779321AC40@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AC40@SRMANNING.eng.emc.com>
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

goggin, edward wrote:
> Reposting since it didn't get much response initially and the issue came up
> again
> in yesterday's multipath conference call.
> 

>>
>>While this isn't an issue now, it could become one later
>>when/if linux hosts are configured with hundreds/thousands
>>of passive paths.
>>
> 

There are already issues out there, these were not directly with
multipath, but should serve as examples.

An SGI Altix box with 8 HBA ports connected via a fabric to 4 Engenio dual
controller raids (2 ports on each controller). From what I recall there were 4
LUNs assigned to each controller on each raid. I think there were 1024 paths
in the complete configuration. This was actually a very small version of
the planned production system which has multiple hosts and several thousand
LUNs.

Path ping pong during partition table scanning took several hours
to resolve itself (we gave up waiting and went home for the day).

The issue was made worth by attempts at parallelism and retries in
the logic. Multiple device reads were issued in parallel
via udev to all the different paths to devices, these reads
did retries on failures. Since a trespass (or automatic volume
transfer, depending on your terminology), causes a failure on
the active path on this raid, end result was it takes a lot of
I/O failures before one actually works.

Once all this completed, various volume manager components then
came along and tried to look for their metadata at the other
end of the LUNs. The same chaos ensues.

Engenio has actually added code to their raid firmware which
lets you turn off automatic transfers within the first few
blocks of the disk. This deals with partition scanning for the
most part. There is no code to deal with metadata scanning
at the end of luns, just don't do it.

There are Linux SANs in production where the reboot of a
single node in a fabric causes all the active nodes to suffer
major performance problems as paths get moved out from under
them.

In the RDAC mode of operation instead of the path ping pong
issue, you still end up with slow I/O failures on the
standby paths. Nowhere near as bad, but still painful
once you scale things up.

Steve

p.s. is anyone working on multipath modules for Engenio devices?
