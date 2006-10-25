From: Jonathan Brassow <jbrassow@redhat.com>
Subject: kernel mirror patches for device-mapper
Date: Wed, 25 Oct 2006 14:57:58 -0500
Message-ID: <1161806278.21797.4.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2Gf88sOj4r/jWM/iTM+G"
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
To: dm-devel@redhat.com, heinzm@redhat.com, jbrassow@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


--=-2Gf88sOj4r/jWM/iTM+G
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Given that we haven't come to a decision on how to do read balancing yet
and that patch is holding up consideration of other patches, I've
decided to reorder some of the patches - putting them before read
balancing.

Please consider the following set for inclusion.

 brassow

P.S.  I thought the "proper suspend" patch was upstream already, but I
haven't noticed it there.


--=-2Gf88sOj4r/jWM/iTM+G
Content-Disposition: attachment; filename=2.6.18.1-mirror_patches.tgz
Content-Type: application/x-compressed-tar; name=2.6.18.1-mirror_patches.tgz
Content-Transfer-Encoding: base64

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
hhpqqKGGGmqooYYaaqihF6H/AAQ/aWcAUAAA


--=-2Gf88sOj4r/jWM/iTM+G
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-2Gf88sOj4r/jWM/iTM+G--
