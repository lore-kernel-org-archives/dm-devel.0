From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Reloading multipathd?
Date: Wed, 07 Nov 2007 14:07:50 +0100
Message-ID: <1194440870.6012.8.camel@sanderbal>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi...

I just added another LUN on our storage (MD3000). But now that I run
multipath -ll I don't see the new LUN.

Do I need to reload something (like /etc/init.d/multipath-tools reload
maybe)? And if so, can I do this without it interrupting the
connectivity of the other (production) LUN's?

Sander
