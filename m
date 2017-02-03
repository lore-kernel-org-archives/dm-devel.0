From: Marian Csontos <mcsontos@redhat.com>
Subject: Re: unable to send mails to
 christophe.varoqui@opensvc.com using git
Date: Fri, 3 Feb 2017 17:40:31 +0100
Message-ID: <0fb47d0d-fce8-1c55-60b3-593056c4005f@redhat.com>
References: <2d3265b9e6094cb2a3807d7c248c0c1b@BRMWP-EXMB12.corp.brocade.com>
	<20170203155156.GI22981@octiron.msp.redhat.com>
	<28ddb8f82cb84549ae9058ebca9dac54@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <28ddb8f82cb84549ae9058ebca9dac54@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mmandala@Brocade.com
List-Id: dm-devel.ids

On 02/03/2017 05:31 PM, Muneendra Kumar M wrote:

>        550 5.1.8 <root@localhost.localdomain>: Sender address rejected:
>    Domain not
>
>        found (in reply to RCPT TO command)

Hi Muneendra, you need to setup From header to send the email from an 
address with a recognized domain.

There is no localdomain domain as there is no localhost.

IIUC this is one of protection measures against spam.

-- Martian
