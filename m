From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: Manual failback commands
Date: Wed, 03 Feb 2010 17:59:02 +0100
Message-ID: <1265216342.26432.9.camel@zezette>
References: <4B68C5A7.8090303@gps.caltech.edu>
	<1265159278.19083.11.camel@zezette> <4B69A924.7010000@gps.caltech.edu>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B69A924.7010000@gps.caltech.edu>
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

On mer., 2010-02-03 at 08:49 -0800, Scott Dungan wrote:
> > On mar., 2010-02-02 at 16:39 -0800, Scott Dungan wrote:
> >    
> >> Hello all.
> >>
> >> If we set a device to manual failback, how does one command the
> >> multipathd service to reinstate the path when we have decided the path
> >> is indeed ready to accept IO?
> >>
> >>      
> > paths are automatically reinstated by multipathd.
> >
> > The 'failback' parameter means the original path_group is not
> > re-activated after a switch-over to a secondary path_group.
> >
> > You can force multipathd to not reinstate a path using the CLI (or
> > pro-actively disable it).
> >    
> Thanks for the clarification. I think I understand this better now. 
> Would it be possible to post CLI example(s) of reinstating or disabling 
> a path? I cannot seem to find such an example in documentation or other 
> available resources.
> 

The cli has a syntax help message, accessed using 'help' or whatever
unknown keyword.

The relevant commands are:
 reinstate path $path
 fail path $path

which wrap 1/ the dm messaging to fail/resinstate a path and 2/
disable/enable the specified path checking in multipathd

-- 
cvaroqui,
http://www.opensvc.com
