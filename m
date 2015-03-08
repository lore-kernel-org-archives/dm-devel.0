From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 11/15] multipath: enable configuration
 directory
Date: Sun, 8 Mar 2015 23:27:06 +0100
Message-ID: <20150308232706.000039e7@localhost>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
	<1425785506-20419-12-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-12-git-send-email-bmarzins@redhat.com>
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
Cc: Sebastian Herbszt <herbszt@gmx.de>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Benjamin Marzinski wrote:
> Users who setup multipath on many machines sometimes want a core
> configuration file that stays the same on all machines, and also secondary
> configuration files that are unique to each machine to set blacklists and
> aliases.  This patch enables this by adding a new configuration option,
> "config_dir", which defaults to "/etc/multipath/conf.d". If this is set,
> multipath will check this directory for files ending in .conf, and apply
> them on top of the initial configuration file in alphabetical order.

How about using "/etc/multipath.conf.d" instead of "/etc/multipath/conf.d" ?

Sebastian
