From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH V6 1/3] multipath-tools: New way to limit the
 IPC command length.
Date: Fri, 12 Aug 2016 14:49:01 -0700
Message-ID: <088171f0-7e0c-7e94-ee4a-bc4fbba7e898@sandisk.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160712065038.17565-1-fge@redhat.com>
	<20160712065038.17565-2-fge@redhat.com>
	<20160715213545.GP8095@octiron.msp.redhat.com>
	<c9179069-b0a9-f409-860b-7b889a3cd654@sandisk.com>
	<20160812213559.GP26062@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160812213559.GP26062@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Gris Ge <fge@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/12/2016 02:36 PM, Benjamin Marzinski wrote:
> On Fri, Aug 12, 2016 at 08:57:51AM -0700, Bart Van Assche wrote:
>> Subject: [PATCH] libmultipath, multipathd: Rework SIGPIPE handling
>>
>> The behavior we want is as follows:
>> * If stdout is closed then multipathd stops due to SIGPIPE.
>
> I still don't understand why we ever what multipathd quitting with
> SIGPIPE.  I would much rather that the call return EPIPE and multipathd
> printed a useful error message, instead of simply quitting.
>
> Also, I don't really like putting stuff that messes with signals in the
> libmpathcmd library.  Some users might want their program to get get
> those SIGPIPEs so they can handle them a certain way.  It seems like,
> since it isn't necessary to block the signal for this to work correctly,
> we should not be blocking it in the library, and multipathd should
> continue to make sure that it is ignoring the SIGPIPEs.

Hello Ben,

Regarding quitting upon SIGPIPE: when running a command like "multipathd 
-d | head -n 1" then multipathd should quit as soon as the "head" 
command has finished reading the first output line. That's why I think 
that multipathd (and other executables) shouldn't ignore SIGPIPE when 
writing to stdout or stderr.

Regarding libmpathcmd and SIGPIPE: the only applications that should 
exit through SIGPIPE when writing to a socket are applications for which 
stdout and/or stderr are redirected to a socket, e.g. daemons started by 
inetd. For these daemons it is very important that these are stopped by 
SIGPIPE if the other end of the socket connection is closed. However, 
for the kind of socket communication that is performed by multipathd and 
multipath I don't think it is useful to let socket closure trigger 
SIGPIPE. This is why I think we need MSG_NOSIGNAL or the equivalent 
setsockopt(sd, SOL_SOCKET, SO_NOSIGPIPE, ...) in multipath and multipathd.

Thanks,

Bart.
