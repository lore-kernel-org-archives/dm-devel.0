From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Support for CCISS for multipath
Date: Thu, 20 Apr 2006 07:12:38 +0200
Message-ID: <44471846.5070104@free.fr>
References: <6B07290940B2C14BA4567FABFDE6024D88096C@bgeexc04.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6B07290940B2C14BA4567FABFDE6024D88096C@bgeexc04.asiapacific.cpqcorp.net>
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

Kumar, Satish (STSD) a =E9crit :
> =20
>
> Hi All,
>
> Is CCISS devices supported as dm multipath targets?
> Even though the utilities to identify a unique id for
> CCISS devices may not be present and hence it may be
> difficult to configure them, are the other kernel changes
> to support CCISS already present?=20
>
>  =20
/dev/cciss/* are blacklisted in the internal defaults.
You would have to override the hardcoded blacklist.
Ideally, we should be able to blacklist SA* monopathed devices and still=20
allow for multipathed ones, though they may all be driven by the cciss=20
driver. Have an idea how?

Is this for the SAS controlers ?


Regards,
cvaroqui
