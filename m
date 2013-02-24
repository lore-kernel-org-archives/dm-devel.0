From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] Fix gzip path in Makefile.inc
Date: Sun, 24 Feb 2013 16:43:47 +0100
Message-ID: <1361720627.7812.4.camel@lapoo.opensvc.com>
References: <5126A3FA.8070807@mail.ru>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5126A3FA.8070807@mail.ru>
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

On jeu., 2013-02-21 at 23:47 +0100, Phileas Fogg wrote:
> i would like to submit a patch which fixes the path to gzip in
> Makefile.inc
> Makefile.inc uses the absolute path /bin/gzip which isn't valid on all
> Linux 
> distros. E.g. on Arch Linux which i'm cuurrently using the gzip tool
> is 
> installed in /usr/bin/gzip. The patch fixes the build problem on Linux
> distros 
> which do not have gzip in /bin directory.

Applied.

Thanks,
Christophe Varoqui
www.opensvc.com
