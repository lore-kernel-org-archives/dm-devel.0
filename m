From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: Manual failback commands
Date: Wed, 03 Feb 2010 20:33:04 +0100
Message-ID: <1265225584.26432.11.camel@zezette>
References: <4B68C5A7.8090303@gps.caltech.edu>
	<1265159278.19083.11.camel@zezette> <4B69A924.7010000@gps.caltech.edu>
	<1265216342.26432.9.camel@zezette> <4B69B5F1.8030801@gps.caltech.edu>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B69B5F1.8030801@gps.caltech.edu>
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

On mer., 2010-02-03 at 09:44 -0800, Scott Dungan wrote:
> > The cli has a syntax help message, accessed using 'help' or whatever
> > unknown keyword.
> >
> > The relevant commands are:
> >   reinstate path $path
> >   fail path $path
> >
> > which wrap 1/ the dm messaging to fail/resinstate a path and 2/
> > disable/enable the specified path checking in multipathd
> >
> >    
> Thanks for your continued help. Perhaps I am using the incorrect tools. 
> Neither the 'multipath' command or the interactive mode of the 
> multipathd daemon (multipath -k) have any of those directives documented 
> under the 'help' listing, nor do they respond to them when I use them as 
> you specify above. What CLI command are you using with those directives? 
> Like:
> 
> %cli_command% reinstate path $path
> 
'multipathd -khelp' on most distro-shipped multipath-tools.
'multipathd help' is also possible with upstream.
