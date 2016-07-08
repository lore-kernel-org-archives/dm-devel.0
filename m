From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/5] Makefiles housekeeping II
Date: Fri, 8 Jul 2016 15:02:27 +0200
Message-ID: <9c6414eb-d869-18c1-816e-67847ddbbd00@gmail.com>
References: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-Gnccm_uvdVFkWK2XonVqm_QPTYSxW+TAYBzT4r=NEmfqKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnccm_uvdVFkWK2XonVqm_QPTYSxW+TAYBzT4r=NEmfqKQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/08/2016 09:16 AM, Christophe Varoqui wrote:

> Merged patches 1, 2 and 3 of this set.
> 
> I postponed merging the patches adding fullpath links in libs.
> Are you sure it is best practice to use fullpaths there ?

This is up to you. It works as is.

But in "libmpathpersist/Makefile" is done as in my patch:
$ git grep '$(LN) $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)'
libmpathpersist/Makefile:       $(LN) $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)

Let me know your preference.
