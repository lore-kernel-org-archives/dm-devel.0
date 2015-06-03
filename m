From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 03/10] multipathd: use /run instead of
 /var/run
Date: Wed, 3 Jun 2015 23:38:32 +0200
Message-ID: <20150603233832.00002732@localhost>
References: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
	<1431731653-3892-4-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431731653-3892-4-git-send-email-bmarzins@redhat.com>
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
> /var/run is usually a symlink to /run.  If /var is on a separate
> filesytem, when multipathd starts up, it might end up writing to
> /var/run before the /var filesytem is mounted and thus not have
> its pidfile accessible at /var/run afterwards.  /run is a tmpfs and
> should always be available before multipathd is started, so
> multipath should just write there directly, instead of through the
> symlink.

My older openSUSE doesn't have a /run directory.
Should this maybe depend on systemd or something else?

Sebastian
