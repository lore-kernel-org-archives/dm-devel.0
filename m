From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath info: wwid
Date: Wed, 07 Sep 2005 20:52:46 +0200
Message-ID: <1126119166.17815.23.camel@zezette>
References: <431F0FC0.7010805@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <431F0FC0.7010805@theorematica.it>
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

On mer, 2005-09-07 at 18:05 +0200, Nicola Murino wrote:
> Thanks for the glossary now I understand well some things,
> 
> only another question, the wwid is given from the output of the command:
> 
> multipath -ll
> 
> or there is another way?
> 
> excuse me if the question is trivial but I have only a machine with
> multipath and is in production with kernel 2.4.21 so I cannot test
> directly multipath-tools before I format next saturday and I would like
> to reduce the downtime collecting more possible info before installation,
> 
scsi_id(8) is used by default by multipath(8) to get path unique
identifiers.

You can plug another callout if you want.

Excuse me if the suggestion is trivial but ... make backups :)

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
