From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 09/14] libmultipath: check whether
 mp->features is NULl in, assemble_map
Date: Mon, 7 Sep 2020 20:21:28 +0800
Message-ID: <8dd72a70-991a-cb7d-3279-3d5036df1b9d@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<40cf77df-eaa3-fb72-69fd-9f865d12dc34@huawei.com>
	<20200904213048.GE11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200904213048.GE11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids


>> @@ -86,9 +86,12 @@ assemble_map (struct multipath * mp, char * params, int len)
>>  	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
>>  		add_feature(&mp->features, retain_hwhandler);
>>
>> -	f = STRDUP(mp->features);
> 
> clearly strdup()ing without checking if mp->features NULL is incorrect.
> However, I'm not sure that we need to fail if mp->features is NULL.
> instead, int the APPEND call, we could use the gcc ternary operator
> extension
> 
> (mp->features)?: "0"
> 
> to use "0" if mp->features is NULL.
> 
> Also, have you seen this actually occur?  Or is this just a theoretical
> issue that you've found from reading the code.  It seems like
> setup_map() will always call select_features() before calling
> assemble_map(), which should mean that mp->features will always be set
> in this case. Perhaps I'm missing something here.
> 
> -Ben
> 
Hi Ben,
  This just a theoretical issue and I did not see it. But it's not necessary
to call strdup. In your opinion, need multipath be checked?  I will make new
patch with your suggestion.

-Lixiaokeng
>> +	if (!mp->features) {
>> +		condlog(0, "mp->features is still NULL.");
>> +		goto err;
>> +	}
