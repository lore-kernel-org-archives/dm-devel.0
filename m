From: Tore Anderson <tore@linpro.no>
Subject: multipathd sometimes not reinstating paths
Date: Tue, 29 Jul 2008 14:35:57 +0200
Message-ID: <200807291435.57935.tore@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I've on several occasions seen that multipathd fails to reinstate paths 
that has recovered.  Yesterday I had a controller meltdown on an array, 
and several hosts ended up stuck in a all-paths-down state, which a 
simple restart of multipathd fixed.  It's as if multipathd at some 
point stopped to check dead paths for revival.  The hosts were running 
0.4.7 and 0.4.5 (RHEL4/5 and Debian 4.0).

Since getting things back on line was the priority I didn't get around 
to debugging it, unfortunately.  I've seen this before many times, 
though, so I'm wondering if anybody else has seen this and know what 
causes it?  Is there any known workarounds or ways to avoid it?

Any suggestions on how to debug it if I see it happen again?

Regards,
-- 
Tore Anderson
