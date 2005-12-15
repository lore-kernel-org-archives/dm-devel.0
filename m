From: egoggin@emc.com
Subject: Requiring a hwtable entry for a dm target device?
Date: Thu, 15 Dec 2005 16:29:35 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AEB9@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Currently a dm target device which is not blacklisted need not have a
corresponding hwentry in either libmultipath/hwtable.c or
/etc/multipath.conf
for the target device to be recognized and a multipath mapped device
created for it.  Is this desirable, possibly for multipathing to JBOD?

An alternative is to require that a hwentry be found and fail to recognize
the target device otherwise.  Doing so has the distinct advantage of being
able to use the regular expression matching logic in find_hwe() to
effectively
blacklist a target device based on the contents of the target device's
vendor
and product device attributes.
