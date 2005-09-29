From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] multipath-tools/kpartx - fix endianes,
	undefined behaviour, cleanup
Date: Thu, 29 Sep 2005 16:13:36 +0200
Message-ID: <20050929141336.GA14667@free.fr>
References: <20050929124115.GA8988@wavehammer.waldi.eu.org>
	<20050929132938.GA14593@free.fr>
	<20050929140529.GA18325@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050929140529.GA18325@wavehammer.waldi.eu.org>
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

On Thu, Sep 29, 2005 at 04:05:29PM +0200, Bastian Blank wrote:
> On Thu, Sep 29, 2005 at 03:29:38PM +0200, Christophe Varoqui wrote:
> > I can't read actual file from my machines, though I can browse the structure with a browser.
> 
> Hu? I can clone the tree without problems.
> 
xa-s05:/tmp# wget http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git/refs/heads/
--16:11:42--  http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git/refs/heads/
           => `index.html'
Connexion vers 10.8.86.78:3128...connect
requ\uffffte Proxy transmise, en attente de la r\uffffponse...200 OK
Longueur: 826 [text/html]

100%[=============================================================================>] 826           --.--K/s

16:11:42 (87.53 MB/s) - \uffff index.html \uffff sauvegard\uffff [826/826]


*** browse is ok, but ***



xa-s05:/tmp# wget http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git/refs/heads/master
--16:11:45--  http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git/refs/heads/master
           => `master'
Connexion vers 10.8.86.78:3128...connect
requ\uffffte Proxy transmise, en attente de la r\uffffponse...403 Forbidden
16:11:45 ERREUR 403: Forbidden.
