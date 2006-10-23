From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [RFC] Change to the mirror table map
Date: Mon, 23 Oct 2006 18:01:53 +0200
Message-ID: <OFD597D136.7095259E-ONC1257210.00549799-C1257210.0057CA37@de.ibm.com>
References: <c333ab79987a0006c182eb7d041e3fc7@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c333ab79987a0006c182eb7d041e3fc7@redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

dm-devel-bounces@redhat.com wrote on 20.10.2006 21:36:54:
> 
> > "disk" is format2.
> 
> or "clustered_disk" or "clustered_core" or any other logging 
> implementation that we may develop in the future, like "multi_disk". 
> The problem is, then we need to either encode all those in the 
> mirror_ctr or wait for 'create_dirty_log' to return NULL - then pass on 
> to the second format, which may also return an error.
> 
> And if we again decide to change the format in the future...
> 
> With the format argument, we don't need the extra logic.  We simply 
> pass on the rest to the correct constructor function for that format.
> 
Well, I guess this is just a minor issue. It is a simple approach to
to it that way. My point was just that "core" and "disk" (if these
were not used as section label) would indicate the old format. The
new parser would get used for all formats, simply skipping sections
that it doesn't understand. But "formatX" is ok.


> For simplicity, I've kept the offset (pvmove uses it), removed the 
> status arg, and made the section argument count consistent.  I now 
> think it should look something like:
>      devices 4 253:3 0 253:4 0
> (The example patch expects this.)
> 
> >    devices 2 2 253:3 rr_min=1000 3 253:4 mstate=m rr_min=1000
> > be done more than once...
> 
> I agree that having to state a device multiple times is ugly.  However, 
> I don't like parsing sections multiple times for different things.  I'd 
> really like to have a 'section to function' mapping if possible. 
> Additionally, we can't be sure what extra information (sections) we may 
> add in the future.  (Think device status, or other).  That could be 
> solved by your solution above and would simply change the per device 
> argument count; but again, I'd like to avoid parsing the same section 
> multiple times - or mangling the order of parameters to much just to 
> pass them to say, the path selector constructor for read balancing.)
> 
Yes, it makes it simpler to break up parsing. The other approach, while
it might be simpler to read would mean every place interrested in device
options would have to parse them again. And it would require all parsers
to change. And that is a too big change.
What makes me a bit uneasy about having devices in several places is that
this allows configuration mistakes that could be fatal. For example give
different devices to device section and round-robin section...

> 
> Thank-you for your comments Stefan.  Below is a quick patch of how I 
> would see the code changes for the constructor.  (I didn't put in the 
> per-section functions.  Nor did I put in the read balancing stuff yet. 
> This is just an example of how to make the constructor more flexible... 
> paving the way for read balancing.)
> 
Well, besides my "bad feelings" this looks good to me. But at the moment
I can't think of a better solution that wouldn't require changes to other
parsers. :( 

Regards,
Stefan
