From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH V5 3/3] Introducing multipath C API
Date: Sun, 10 Jul 2016 18:26:53 +0200
Message-ID: <77cd4f5a-2783-6365-7375-f809d699adda@gmail.com>
References: <90c5e679-2942-12ce-4e77-9cc1f475ee45@gmail.com>
	<20160705031719.GA4128@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160705031719.GA4128@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/05/2016 05:17 AM, Gris Ge wrote:

> On Mon, Jul 04, 2016 at 06:32:56PM +0200, Xose Vazquez Perez wrote:
>> Gris Ge wrote:
>>
>>> +	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
>>> +		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
>>
>> Please, replace perl with sed, awk or any other basic tool.
> 
> it's quit complex to handle folder path with '/' in sed or
> awk unless I missed anything.
> 
> As we need perl in 'kernel-doc' tool blow to generate manpage,
> can I keep it?
>
>>> +	perl docs/kernel-doc -man $(HEADERS) | perl docs/split-man.pl docs/man
>>> +	@for file in docs/man/*.3; do \
>>> +		gzip -f $$file; \
>>> +	done
>>> +	find docs/man -type f -name \*[0-9].gz
> 

This is up to Christophe's taste.
