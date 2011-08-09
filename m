From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm crypt: Always disable discard zeroes data flag
Date: Tue, 09 Aug 2011 08:44:29 +0200
Message-ID: <4E40D74D.4040007@redhat.com>
References: <1312840093-4731-1-git-send-email-mbroz@redhat.com>
	<20110808220527.GD10390@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110808220527.GD10390@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/09/2011 12:05 AM, Mike Snitzer wrote:
>> +	ti->discard_zeroes_unsupported = 1;
> 
> I'd prefer 'discard_zeroes_data_unsupported'

It was too long and I am lazy typist :-)
In fact, I know Alasdair will rename it anyway so
I do not care about the final name.

Milan
