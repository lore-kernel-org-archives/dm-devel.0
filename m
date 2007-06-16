From: Guido Guenther <agx@sigxcpu.org>
Subject: [multipath 0/3] move *_id helpers to /lib/udev
Date: Sat, 16 Jun 2007 20:25:10 +0200
Message-ID: <20070616182509.GA26641@bogon.ms20.nix>
References: <11820172361537-git-send-email-agx@sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <11820172361537-git-send-email-agx@sigxcpu.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
the *_id helpers are supposed to be found in /lib/udev instead of sbin
since version 089 of udev. Current is udev 112, the just posted patches
do this.
Cheers,
 -- Guido

Signed-Off-By: Guido Guenther <agx@sigxcpu.org>
