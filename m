From: Milan Broz <mbroz@redhat.com>
Subject: Re: kernel NULL pointer after snapshot remove on 2.6.17
Date: Tue, 03 Oct 2006 15:34:58 +0200
Message-ID: <45226702.5050003@redhat.com>
References: <1159881164.19882.21.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1159881164.19882.21.camel@localhost.localdomain>
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

This is known bug, patch already in -mm tree.

For patch see http://bugzilla.kernel.org/show_bug.cgi?id=7040

Milan
--
mbroz@redhat.com

Brice Figureau wrote:
> Hi,
> 
> I just found the following oops after lvremove'ing a snapshot which was
> used to backup a mysql database.
> 
> This oops happened because I mistakenly copied a part of the snapshot
> back to the original volume. This apparently exhausted the capacity of
> the snapshot and triggered the following oops.
> 
> lvremove after the oops was stuck in D+ state. 
> Any lv* command was also stuck after that.
> After that the server was stuck while rebooting with the error message:
> "snapshot is marked invalid", then nothing else.
> 
> I cured the problem by booting a rescue CD, and hand-lvremoving the
> offending snapshot.
> 
> All this is on an amd64 debian etch with custom compiled kernel version
> 2.6.17, and lvm2 version 2.02.06-2, and libdevmapper is at 1.02.08-1.
> 
