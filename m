From: "goggin, edward" <egoggin@emc.com>
Subject: path priority group and path state
Date: Thu, 10 Feb 2005 11:48:03 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A783@SRMANNING.eng.emc.com>
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
Cc: 'christophe varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

The multipath utility is relying on having at least one block
read/write I/O be serviced through a multipath mapped
device in order to show one of the path priority groups in
an active state.  While I can see the semantic correctness
in this claim since the priority group is not yet initialized,
is this what is intended?  Why show both the single priority
group of an active-active storage system using a multibus
path grouping policy and the non-active priority group of an
active-passive storage system using a priority path grouping
policy both as "enabled" when the actual readiness of each
differs quite significantly?

Also, multipath will not set a path to a failed state until the
first block read/write I/O to that path fails.  This approach
can be misleading while monitoring path health via
"multipath -l".  Why not have multipath(8) fail paths known to
fail path testing?  Waiting instead for block I/O requests to
fail lessens the responsiveness of the product to path failures.
Also, the failed paths of enabled, but non-active path priority
groups will not have their path state updated for possibly a
very long time -- and this seems very misleading.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
