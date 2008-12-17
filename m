From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath -f/-F exit status
Date: Thu, 18 Dec 2008 00:05:23 +0100
Message-ID: <20081218000523.6c57adc8@plop>
References: <20081213125937.2ddc34d6@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081213125937.2ddc34d6@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmr@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The following patch will appear soon at k.org
It should do what you expect.

Thanks for the comment,
cvaroqui

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index bcbeb28..6b289cf 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -568,7 +568,7 @@ dm_flush_maps (void)
                goto out;
 
        do {
-               r += dm_flush_map(names->name);
+               r |= dm_flush_map(names->name);
                next = names->next;
                names = (void *) names + next;
        } while (next);
