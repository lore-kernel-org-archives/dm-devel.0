From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: dm snapshot: log only
Date: Mon, 1 Sep 2008 08:24:36 -0500
Message-ID: <a4e6962a0809010624k33e4214av2236288622c0420f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Is there any way to get dm snapshot to generate only an exception log
of blocks written?  I've been playing around with Venti under Linux
and it would greatly accelerate snapshots to venti if I only have to
process blocks written since the last snapshot instead of scanning the
whole partition.  I've toyed with the idea of keeping origin snapshots
around in between venti snapshots and just processing their exception
log -- but the copy-on-write performance overheads of origin snapshot
may be undesirable.

Thanks for any help,

             -eric
