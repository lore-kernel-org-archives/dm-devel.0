From: "goggin, edward" <egoggin@emc.com>
Subject: missing device-mapper functionality
Date: Fri, 11 Feb 2005 10:09:47 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A78C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

The inability to monitor block I/O statistics via iostat for device-mapper
mapped devices seems like a big loss.  Are there plans to provide this
feature?

Seems like being able to initiate i/o requests to device-mapper target
devices from within a device-mapper target driver is a missing link in
the device-mapper architecture.  Are there plans to provide this feature?

Since the multipath hardware context code for the CLARiion places
path priority group initialization I/O requests directly on its target
device queues it must be the case the CLARiion target devices must
be ones which have a request_fn_proc() queue service function -- which
rules out using other device-mapper mapped devices or md devices as
target devices.  This restriction appears not to be in place for other
storage systems supported by multipath.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
