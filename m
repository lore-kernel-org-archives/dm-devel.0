From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: crash in multipathd
Date: Wed, 02 Feb 2005 23:46:42 +0100
Message-ID: <42015852.6010508@free.fr>
References: <CC9E49E3-72FD-11D9-8EBB-000A95A2734C@nanisky.com>
	<a80f8224e84fa48e92f6e4ad243143ec@fotango.com>
	<42015267.9090109@free.fr>
	<d1785912e4f98968687a3bd6b3084aed@fotango.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <d1785912e4f98968687a3bd6b3084aed@fotango.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Arthur Bergman <abergman@fotango.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

good

I'm not aware of any exotic use of pthreads in the daemon. Do you mean 
we should get rid of pthreads entirely or we should spot the shaky 
pthread use ?

regards,
cvaroqui

Arthur Bergman wrote:

> I discovered what causes it.
>
> I am running with tls disabled, mv /lib/tls /lib/tls.disabled   this 
> is becuase /lib/tls doesn't work very well for xen
>
> Any way we could get multipathd to work without /lib/tls
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
