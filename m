From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: creating partition mappings with different delimiters
Date: Mon, 03 Apr 2006 12:19:22 -0400
Message-ID: <1144081162.3111.32.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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


Where/how does kpartx determine the default delimiter when creating the
partition mappings and nodes?

With Red Hat EL 4 Update 3 during bootup the partition mappings are
getting created in rc.sysinit.  However I find that some of the mappings
have no delimiter while some have 'p' as the delimiter.  I prefer 'p' as
the delimiter.

I have been unsuccessful at finding where kpartx (or is it dmsetup) is
determining what delimiter to use.

Eddie
