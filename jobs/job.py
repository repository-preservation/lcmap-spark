import pyspark

def run():
    sc = pyspark.SparkContext()
    rdd = sc.parallelize(range(3))
    print("Sum of range(3) is:{}".format(rdd.sum()))
    sc.close()

if __name__ == '__main__':
    run()
