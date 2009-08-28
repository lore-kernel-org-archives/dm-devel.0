From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 2] REPLACEMENT PATCHES for "dm log userspace
	status fix 2"
Date: Fri, 28 Aug 2009 00:34:42 -0500
Message-ID: <1251437682.16038.8.camel@hydrogen.msp.redhat.com>
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

I've split up the previously posted patch:
"[PATCH 2 of 2] dm log userspace status fix 2"

with the following two patches:
[PATCH 1 of 2] dm log userspace rearrange ctr args
[PATCH 2 of 2] dm log userspace status fix 2

By rearranging the CTR arguments, we can get around the hackish code
that existed in the previously submitted patch.  Things are now much
more straight forward.

 brassow
