From: "goggin, edward" <egoggin@emc.com>
Subject: shouldn't io_restrictions indicate whether or not I/O
	may be clus tered?
Date: Thu, 10 Feb 2005 15:27:32 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A786@SRMANNING.eng.emc.com>
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

Shouldn't the device-mapper io_restrictions structure include a field
to indicate whether or not I/O may be clustered as indicated by the
setting of the QUEUE_CLUSTER_FLAG bit of the queue_flags field
of the request_queue structures for the target devices?  Otherwise,
couldn't we end up with some I/Os terminated in the I/O prep phase
due to an excess of physical segments in the I/O request?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
