From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: minor edition and
 corrections in multipath.conf.5
Date: Wed, 30 Aug 2017 13:02:45 +0200
Message-ID: <7515fe8c-4aa4-1167-764d-6b913cb6586d@gmail.com>
References: <20170817224214.8085-1-xose.vazquez@gmail.com>
	<1503917121.4546.22.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1503917121.4546.22.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/28/2017 12:45 PM, Martin Wilck wrote:
> On Fri, 2017-08-18 at 00:42 +0200, Xose Vazquez Perez wrote:
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  multipath/multipath.conf.5 | 62 +++++++++++++++++++++++++++---------
>> ----------
>>  1 file changed, 36 insertions(+), 26 deletions(-)
>>
>> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
>> index d9ac279..a78ec5b 100644
>> --- a/multipath/multipath.conf.5
>> +++ b/multipath/multipath.conf.5
>>
>> @@ -26,6 +27,8 @@ is the configuration file for the multipath daemon.
>> It is used to
>>  overwrite the built-in configuration table of \fBmultipathd\fP.
>>  Any line whose first non-white-space character is a '#' is
>> considered
>>  a comment line. Empty lines are ignored.
>> +.PP
>> +Internal multipathd configuration can be displayed with the
>> \fBmultipath -t\fR command.

> This is not quite correct. Firstly, please refer to "multipathd show
> config" as well. Secondly, both commands show the full set of
> configuration settings, not just the internal one.
> 
> Apart from that, ACK.

I sent an additional patch to clarify it:
[PATCH v2] multipath-tools: clarify how to dump the multipathd config
https://marc.info/?l=dm-devel&m=150396404301446
