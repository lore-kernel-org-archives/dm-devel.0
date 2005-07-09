From: "goggin, edward" <egoggin@emc.com>
Subject: Re: several small issues
Date: Sat, 9 Jul 2005 19:02:57 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB5D@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 09 Jul 2005 15:02:42 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote

> On ven, 2005-07-08 at 00:09 -0400, goggin, edward wrote:
> > Christophe,

> > ...
> >
> > (2) Could you append a "\n" to the logging string in the 
> call to condlog()
> > from
> > get_word() in libmultipath/util.c?  Doing so helps the 
> readability of the
> > event
> > log when starting multipathd with "-v4".
> > 
> May be I should just comment this log now that this code path 
> is stable.
> Anyway, I don't really see the readability problem you mention ...

It is really difficult to see where one event log file entry
ends and another begins without the new line separator character.

> 
> > (3) Could you change checkerloop() in multipathd/main.c to 
> call LOG_MSG
> > with the checker message if the path state is failed?  This 
> would be useful
> > for administrators and it also helps our debugging -- it 
> helps point out
> > cases
> > where multipathd may think a path's checker state is failed 
> even when
> > "multipath -l" shows otherwise.
> > 
> done, only for '-v4', and whatever the check return value.

Sounds great.

> 
> > (4) The multipathd is dying when I send it a "show paths" 
> or "display paths"
> > message.  I haven't debugged it to know what's wrong.
> > 
> Not for me, so I'll let you dig this one ...

Ok, I'll try to get you something Monday or Tuesday next week.
