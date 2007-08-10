From: "S. J. van Harmelen" <svanharmelen@xillan.nl>
Subject: Multipath-tools errors
Date: Fri, 10 Aug 2007 16:50:47 +0200
Message-ID: <1186757447.17449.24.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Oke, got a bit further...

I now understand how to use the disks. Only thing thats not going oke is
that I get these errors constantly (while formatting):

end_request: I/O error, dev sdf, sector 30408704
end_request: I/O error, dev sdf, sector 30670848
end_request: I/O error, dev sdf, sector 30932992
end_request: I/O error, dev sdf, sector 31195136
end_request: I/O error, dev sdf, sector 31457280

or (while editting a file):

end_request: I/O error, dev sdc, sector 966656
device-mapper: multipath: Failing path 8:32.
end_request: I/O error, dev sdc, sector 966720
device-mapper: multipath: Failing path 8:32.
end_request: I/O error, dev sdc, sector 96665

And the device seems very slow...

And also stil having this error: "error calling out mpath_prio_rdac"

Any tips, pointers?

Sander

-------- Forwarded Message --------
From: S. J. van Harmelen <svanharmelen@xillan.nl>
To: dm-devel@redhat.com
Subject: Re: Multipath-tools
Date: Fri, 10 Aug 2007 11:47:01 +0200

Hi again,

Seem to have found the solution for the first question. Got
multipath-tools up and running now :)

But please do answer the others questions if you have a minute to
spare...

Also I'm seeing "error calling out mpath_prio_rdac" when starting
multipathd?! Any word on that one?

Regards,

Sander



On Fri, 2007-08-10 at 10:27 +0200, S. J. van Harmelen wrote:
> Hey guys,
> 
> Sorry to bother you, but I have a question I think you can answer. I
> also send this message to Christophe, but I don't know how long he takes
> to respond. I'm trying to set up a Dell NX1950 which has an RDAC MD300
> array connected with linux.
> 
> Now I got all thinks working, but the RDAC driver. I'm trying to use the
> opensource multipath-tools (which I want to compile myself), but I have
> some questions about it:
> 
> 1) While compiling I get an error saying: "/usr/bin/ld: cannot find
> -ldevmapper" Can you tell me what I can do to fix this error?
> 
> 2) Can you tell me if there is a mailinglist for the multipath-tools?
> 
> 3) Can you point me to some documentation about configuring the
> multipath-tools with the new RDAC path checker?
> 
> Thanks very much for your time!
> 
> Kind regards,
> 
> Sander van Harmelen
