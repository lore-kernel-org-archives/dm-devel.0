From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath-tools make rpm failure
Date: Thu, 22 Oct 2009 21:31:02 +0200
Message-ID: <1256239862.4801.9.camel@zezette>
References: <4ebf5d590910220144n37fdf3c2s870d7c22e810b252@mail.gmail.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ebf5d590910220144n37fdf3c2s870d7c22e810b252@mail.gmail.com>
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

On jeu., 2009-10-22 at 10:44 +0200, Eyal Gordon wrote:
> Hello,
> 
> I received the following error while trying to run 'make rpm' for
> multipath-tools. My local git repository is a clone of the upstream
> master branch from today.
> 
> # make rpm
> sed -e "s/__VERSION__//" \
>         multipath-tools.spec.in > multipath-tools.spec
> rpmbuild -bb multipath-tools.spec
> error: line 6: Empty tag: Version:
> make: *** [rpm] Error 1
> 
> 
> After looking at the Makefile and adding echo statements to debug, it
> seems that a ${VERSION} variable is required for the above 'sed'
> statement, but it is not defined.
> 
> Could anyone help me please? 
> 
The make file tries to guess the version from the dirname, which is a
convenient trick for distributors, but admittedly not fair for
developpers.

You can still forge a VERSION value. 0.4.8-git091022 would certainly be
a safe choice.

Regards,
cvaroqui
