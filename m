From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] [RFC] [PATCH] Add alias_prefix to get
 multipath names based on	storage type
Date: Fri, 16 Jul 2010 09:12:55 +0200
Message-ID: <1279264375.30600.744.camel@localhost>
References: <b4d519b4bbc657671382.1277260053@malahal>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b4d519b4bbc657671382.1277260053@malahal>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On mar., 2010-06-22 at 19:27 -0700, Malahal Naineni wrote:
> The current multipath tools use "mpath" prefix for all LUNs when
> user_friendly_names is set. It would be nice if the names are generated
> based on the storage subsystem. For example, all EMC LUNs would be named
> emc_a, emc_b, elm_c etc., and all IBM's SVC LUNs would be named svc_a,
> svc_b, svc_c. This patch attempts to do that using only multipath.conf.
> Patches can be added to the internal hardware table, if needed.
> 
I merged this patch finally. Only Hannes cared to comment, but he sure
looked enthusiastic ;)

Thanks for this work.
Regards,

-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
