From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 1/3] Extremely basic hp hardware handler (no
	retries, no error handling, etc).
Date: Mon, 30 Jul 2007 16:08:35 -0500
Message-ID: <46AE5353.2050002@cs.wisc.edu>
References: <20070726044447.846195205@redhat.com>	<20070726044720.403731599@redhat.com>
	<1185476962.17399.52.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1185476962.17399.52.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Chandra Seetharaman wrote:
> Hi Dave,
> 
> some coding style related comments (below).
> 


>> +	if (!error) {
>> +		err_flags = 0;
>> +		DMDEBUG("%s path activation command - success",
>> +		       	path->dev->name);
> 
> Mixed use of space and tab for indentation (many other places too).
> 

Where is that rule for this type of plcae?

I think that is fine in those types of places. In fact I would leave it 
with mixed because that is how the rest of the dm code does it.


>> +	memset(&req->cmd, 0, BLK_MAX_CDB);
>> +	req->cmd[0] = START_STOP;
>> +	req->cmd[4] = 1;
>> +	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
>> + out:
> 
> I think there will be no space before the label (one more below).
> 

Either is normally fine, but in this case to fit with the other dm code 
that is best.
